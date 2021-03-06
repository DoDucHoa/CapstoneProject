using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using PawNClaw.Data.Const;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using static PawNClaw.Data.Repository.PetCenterRepository;
using System.Net.Http;
using Newtonsoft.Json.Linq;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class SearchService
    {
        IPetCenterRepository _petCenterRepository;
        IBookingRepository _bookingRepository;
        IBookingDetailRepository _bookingDetailRepository;
        ICageRepository _cageRepository;
        ILocationRepository _locationRepository;
        IPetBookingDetailRepository _petBookingDetailRepository;
        IDistrictRepository _districtRepository;
        ICityRepository _cityRepository;

        public SearchService(IPetCenterRepository petCenterRepository, ILocationRepository locationRepository,
            IBookingRepository bookingRepository, IBookingDetailRepository bookingDetailRepository,
            ICageRepository cageRepository, IPetBookingDetailRepository petBookingDetailRepository,
            IDistrictRepository districtRepository, ICityRepository cityRepository)
        {
            _petCenterRepository = petCenterRepository;
            _locationRepository = locationRepository;
            _bookingRepository = bookingRepository;
            _bookingDetailRepository = bookingDetailRepository;
            _cageRepository = cageRepository;
            _petBookingDetailRepository = petBookingDetailRepository;
            _districtRepository = districtRepository;
            _cityRepository = cityRepository;
        }


        //Main Search Center Part 1
        public PagedList<PetCenter> MainSearchCenter(string City, string District,
            string StartBooking, string EndBooking,
            List<List<PetRequestForSearchCenter>> _petRequests, PagingParameter paging)
        {
            //Check loaction
            var values = _petCenterRepository.SearchPetCenter(City, District);

            //START Check valid time booking
            //This is 24 Hours format
            if (StartBooking == null || EndBooking == null)
            {
                throw new Exception("StartBooking or EndBooking is NULL");
            }
            DateTime _startBooking = DateTime.ParseExact(s: StartBooking, format: SearchConst.DateFormat,
                                                        CultureInfo.InvariantCulture);

            DateTime _endBooking = DateTime.ParseExact(s: EndBooking, format: SearchConst.DateFormat,
                                                        CultureInfo.InvariantCulture);
            if (DateTime.Compare(_startBooking, DateTime.Now) <= 0 || DateTime.Compare(_startBooking, _endBooking) >= 0)
            {
                throw new Exception("StartBooking or EndBooking is INVALID");
            }
            //END Check valid time booking

            foreach (var petIds in _petRequests)
            {
                foreach (var petId in petIds)
                {
                    if (_petBookingDetailRepository.GetAll(x => x.PetId == petId.Id &&
                            ((DateTime.Compare(_startBooking, (DateTime)x.BookingDetail.Booking.StartBooking) <= 0
                            && DateTime.Compare(_endBooking, (DateTime)x.BookingDetail.Booking.EndBooking) >= 0)
                            ||
                            (DateTime.Compare(_startBooking, (DateTime)x.BookingDetail.Booking.StartBooking) >= 0
                            && DateTime.Compare(_startBooking, (DateTime)x.BookingDetail.Booking.EndBooking) < 0)
                            ||
                            (DateTime.Compare(_endBooking, (DateTime)x.BookingDetail.Booking.StartBooking) > 0
                            && DateTime.Compare(_endBooking, (DateTime)x.BookingDetail.Booking.EndBooking) <= 0))).Count() != 0)
                    {
                        throw new Exception("Pet is Booking Already");
                    }
                }
            }

            //START Check time booking with open close time from petcenter
            List<PetCenter> validOCCenter = new List<PetCenter>();
            foreach (var center in values)
            {
                string petCenterOpenTime = _petCenterRepository.GetFirstOrDefault(x => x.Id == center.Id).OpenTime;
                string petCenterCloseTime = _petCenterRepository.GetFirstOrDefault(x => x.Id == center.Id).CloseTime;

                //String format = petCenterOpenTime.Length == 5 ? "H\\:mm\\:ss" : "HH\\:mm\\:ss";

                TimeSpan _petCenterOpenTime = TimeSpan.ParseExact(input: petCenterOpenTime, format: SearchConst.TimeFormat,
                                                                CultureInfo.InvariantCulture);

                //format = petCenterCloseTime.Length == 5 ? "H\\:mm\\:ss" : "HH\\:mm\\:ss";

                TimeSpan _petCenterCloseTime = TimeSpan.ParseExact(input: petCenterCloseTime, format: SearchConst.TimeFormat,
                                                                CultureInfo.InvariantCulture);

                if (_petCenterOpenTime < _startBooking.TimeOfDay && _petCenterCloseTime > _startBooking.TimeOfDay
                    && _petCenterOpenTime < _endBooking.TimeOfDay && _petCenterCloseTime > _endBooking.TimeOfDay)
                {
                    validOCCenter.Add(center);
                }
            }
            values = validOCCenter;
            validOCCenter = new List<PetCenter>();
            //END Check time booking with open close time from petcenter


            //START Check Size of Pet
            List<PetSizeCage> PetSizes = new List<PetSizeCage>();

            foreach (var _petRequest in _petRequests)
            {
                int Count = 0;
                decimal Height = 0;
                decimal Width = 0;
                foreach (var _pet in _petRequest)
                {
                    if (Height < (decimal)(_pet.Height + SearchConst.HeightAdd))
                    {
                        Height = (decimal)(_pet.Height + SearchConst.HeightAdd);
                    }

                    Width += (decimal)Math.Round((((double)_pet.Length) + ((double)_pet.Height)) / SearchConst.WidthRatio, 0);
                    Count += 1;
                }

                PetSizeCage petSize = new PetSizeCage();
                petSize.Height = Height;
                petSize.Width = Width;
                if (Count > 1) petSize.IsSingle = false;
                PetSizes.Add(petSize);
            }
            //END Check Size of Pet

            //START Check valid cage for pet
            //Check free cage in time booking
            //Check amount of cage with amount of pet
            //Check size of cage with size of pet (merge with upper line)
            //Get cage code of center store to Map
            List<BookingDetail> BookingDetails = new List<BookingDetail>();
            List<string> CageCodesNotValid = new List<string>();
            Dictionary<int, List<string>> CenterWithCage = new Dictionary<int, List<string>>();

            foreach (var center in values)
            {

                Console.WriteLine(center.Id);

                var BookingOfCenter = _bookingRepository.GetBookingValidSearch(center.Id, _startBooking, _endBooking);

                //If BookingOfCenter is null => That center have cage free for pet
                if (BookingOfCenter.Count() == 0)
                {
                    var CageTypes = center.CageTypes;

                    //Check is fields that check center have any cage valid for pet
                    bool Check = false;
                    List<int> CageTypeCodeIsSelect = new List<int>();
                    foreach (var petsize in PetSizes)
                    {
                        Check = false;

                        foreach (var cagetype in CageTypes)
                        {
                            if (cagetype.Height >= petsize.Height && cagetype.Width >= petsize.Width)
                            {
                                //CageTypeValidCode.Add(cagetype.Id);

                                int CageAmount = 1;
                                int CageTypeCodeIsSelectAmount = CageTypeCodeIsSelect.Where(x => x == cagetype.Id).Count();
                                if (CageTypeCodeIsSelectAmount > 0)
                                {
                                    CageAmount += CageTypeCodeIsSelectAmount;
                                }
                                if (_cageRepository.CountCageByCageTypeIDExceptBusyCage(cagetype.Id, petsize.IsSingle, CageCodesNotValid) >= CageAmount)
                                {
                                    Check = true;
                                    CageTypeCodeIsSelect.Add(cagetype.Id);
                                    break;
                                }
                            }
                        }

                        //If check here is null that 1 of those pet dont have cage in this center
                        if (!Check)
                        {
                            break;
                        }
                    }

                    if (Check)
                    {
                        validOCCenter.Add(center);
                    }
                }
                else
                {
                    foreach (var booking in BookingOfCenter)
                    {
                        //This code is get booking detail of all busy bookings in center
                        BookingDetails = _bookingDetailRepository.GetBookingDetailForSearch(booking.Id).ToList();
                        foreach (var bookingdetail in BookingDetails)
                        {
                            CageCodesNotValid.Add(bookingdetail.CageCode);
                        }
                    }
                    //Here is cage of the center is invalid time with booking
                    //CenterWithCage.Add(center.Id, CageCodesNotValid);
                    //Check center cagetype is valid size
                    //List<int> CageTypeValidCode = new List<int>();
                    var CageTypes = center.CageTypes;

                    //Check is fields that check center have any cage valid for pet
                    bool Check = false;
                    List<int> CageTypeCodeIsSelect = new List<int>();
                    foreach (var petsize in PetSizes)
                    {

                        Check = false;

                        foreach (var cagetype in CageTypes)
                        {
                            if (cagetype.Height >= petsize.Height && cagetype.Width >= petsize.Width)
                            {
                                //CageTypeValidCode.Add(cagetype.Id);
                                int CageAmount = 1;
                                int CageTypeCodeIsSelectAmount = CageTypeCodeIsSelect.Where(x => x == cagetype.Id).Count();
                                if (CageTypeCodeIsSelectAmount > 0)
                                {
                                    CageAmount += CageTypeCodeIsSelectAmount;
                                }
                                if (_cageRepository.CountCageByCageTypeIDExceptBusyCage(cagetype.Id, petsize.IsSingle, CageCodesNotValid) >= CageAmount)
                                {
                                    Check = true;
                                    CageTypeCodeIsSelect.Add(cagetype.Id);
                                    break;
                                }
                            }
                        }

                        //If check here is null that 1 of those pet dont have cage in this center
                        if (!Check)
                        {
                            break;
                        }
                    }

                    if (Check)
                    {
                        validOCCenter.Add(center);
                    }
                }
            }
            //END Check valid cage for pet

            values = validOCCenter;

            values = values.Select(center => new PetCenter
            {
                Id = center.Id,
                Name = center.Name,
                Address = center.Address,
                Phone = center.Phone,
                Rating = center.Rating,
                CreateDate = center.CreateDate,
                Status = center.Status,
                OpenTime = center.OpenTime,
                CloseTime = center.CloseTime,
                Description = center.Description,
                BrandId = center.BrandId
            });

            return PagedList<PetCenter>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        //Main Search Center Part 2
        public PagedList<PetCenter> MainSearchCenter_ver_2(string City, string District,
            string StartBooking, int Due,
            List<List<PetRequestForSearchCenter>> _petRequests, PagingParameter paging)
        {
            //Check loaction
            var values = _petCenterRepository.SearchPetCenter(City, District);

            //START Check valid time booking
            //This is 24 Hours format
            if (StartBooking == null || Due <= 0)
            {
                throw new Exception("StartBooking is NULL");
            }
            DateTime _startBooking = DateTime.ParseExact(s: StartBooking, format: SearchConst.DateFormat,
                                                        CultureInfo.InvariantCulture);

            if (DateTime.Compare(_startBooking, DateTime.Now) <= 0)
            {
                throw new Exception("StartBooking is INVALID");
            }
            //END Check valid time booking

            foreach (var petIds in _petRequests)
            {
                foreach (var petId in petIds)
                {
                    if (_petBookingDetailRepository.GetAll(x => x.PetId == petId.Id &&
                            (DateTime.Compare(_startBooking, (DateTime)x.BookingDetail.Booking.StartBooking) >= 0
                            && DateTime.Compare(_startBooking, (DateTime)x.BookingDetail.Booking.EndBooking) < 0)).Count() != 0)
                    {
                        throw new Exception("Pet is Booking Already");
                    }
                }
            }

            //START Check time booking with open close time from petcenter
            List<PetCenter> validOCCenter = new List<PetCenter>();
            foreach (var center in values)
            {
                string petCenterOpenTime = _petCenterRepository.GetFirstOrDefault(x => x.Id == center.Id).OpenTime;
                string petCenterCloseTime = _petCenterRepository.GetFirstOrDefault(x => x.Id == center.Id).CloseTime;

                //String format = petCenterOpenTime.Length == 5 ? "H\\:mm\\:ss" : "HH\\:mm\\:ss";

                TimeSpan _petCenterOpenTime = TimeSpan.ParseExact(input: petCenterOpenTime, format: SearchConst.TimeFormat,
                                                                CultureInfo.InvariantCulture);

                //format = petCenterCloseTime.Length == 5 ? "H\\:mm\\:ss" : "HH\\:mm\\:ss";

                TimeSpan _petCenterCloseTime = TimeSpan.ParseExact(input: petCenterCloseTime, format: SearchConst.TimeFormat,
                                                                CultureInfo.InvariantCulture);

                if (_petCenterOpenTime < _startBooking.TimeOfDay && _petCenterCloseTime > _startBooking.TimeOfDay)
                {
                    validOCCenter.Add(center);
                }
            }
            values = validOCCenter;
            validOCCenter = new List<PetCenter>();
            //END Check time booking with open close time from petcenter


            //START Check Size of Pet
            List<PetSizeCage> PetSizes = new List<PetSizeCage>();

            foreach (var _petRequest in _petRequests)
            {
                int Count = 0;
                decimal Height = 0;
                decimal Width = 0;
                foreach (var _pet in _petRequest)
                {
                    if (Height < (decimal)(_pet.Height + SearchConst.HeightAdd))
                    {
                        Height = (decimal)(_pet.Height + SearchConst.HeightAdd);
                    }

                    Width += (decimal)Math.Round((((double)_pet.Length) + ((double)_pet.Height)) / SearchConst.WidthRatio, 0);
                    Count += 1;
                }

                PetSizeCage petSize = new PetSizeCage();
                petSize.Height = Height;
                petSize.Width = Width;
                if (Count > 1) petSize.IsSingle = false;
                PetSizes.Add(petSize);
            }
            //END Check Size of Pet

            //START Check valid cage for pet
            //Check free cage in time booking
            //Check amount of cage with amount of pet
            //Check size of cage with size of pet (merge with upper line)
            //Get cage code of center store to Map
            List<BookingDetail> BookingDetails = new List<BookingDetail>();
            List<string> CageCodesNotValid = new List<string>();
            Dictionary<int, List<string>> CenterWithCage = new Dictionary<int, List<string>>();

            foreach (var center in values)
            {

                TimeSpan diffOfDates = DateTime.Parse(center.Checkout.ToString()).TimeOfDay.Subtract(_startBooking.TimeOfDay);

                DateTime _endBooking = _startBooking.AddDays(Due).AddHours(diffOfDates.Hours);

                center.EndBooking = _endBooking;
                //bool CheckPetIsBooked = false;

                //foreach (var petIds in _petRequests)
                //{
                //    foreach (var petId in petIds)
                //    {
                //        CheckPetIsBooked = false;

                //        if (_petBookingDetailRepository.GetAll(x => x.PetId == petId.Id &&
                //                ((DateTime.Compare(_startBooking, (DateTime)x.BookingDetail.Booking.StartBooking) <= 0
                //                && DateTime.Compare(_endBooking, (DateTime)x.BookingDetail.Booking.EndBooking) >= 0)
                //                ||
                //                (DateTime.Compare(_startBooking, (DateTime)x.BookingDetail.Booking.StartBooking) >= 0
                //                && DateTime.Compare(_startBooking, (DateTime)x.BookingDetail.Booking.EndBooking) < 0)
                //                ||
                //                (DateTime.Compare(_endBooking, (DateTime)x.BookingDetail.Booking.StartBooking) > 0
                //                && DateTime.Compare(_endBooking, (DateTime)x.BookingDetail.Booking.EndBooking) <= 0))).Count() != 0)
                //        {
                //            CheckPetIsBooked = true;
                //            break;
                //            //throw new Exception("Pet is Booking Already");
                //        }
                //    }

                //    if (CheckPetIsBooked)
                //    {
                //        break;
                //    }

                //}

                //if (CheckPetIsBooked)
                //{
                //    break;
                //}

                var BookingOfCenter = _bookingRepository.GetBookingValidSearch(center.Id, _startBooking, _endBooking);

                //If BookingOfCenter is null => That center have cage free for pet
                if (BookingOfCenter.Count() == 0)
                {
                    var CageTypes = center.CageTypes;

                    //Check is fields that check center have any cage valid for pet
                    bool Check = false;
                    List<int> CageTypeCodeIsSelect = new List<int>();
                    foreach (var petsize in PetSizes)
                    {
                        Check = false;

                        foreach (var cagetype in CageTypes)
                        {
                            if (cagetype.Height >= petsize.Height && cagetype.Width >= petsize.Width)
                            {
                                //CageTypeValidCode.Add(cagetype.Id);

                                int CageAmount = 1;
                                int CageTypeCodeIsSelectAmount = CageTypeCodeIsSelect.Where(x => x == cagetype.Id).Count();
                                if (CageTypeCodeIsSelectAmount > 0)
                                {
                                    CageAmount += CageTypeCodeIsSelectAmount;
                                }
                                if (_cageRepository.CountCageByCageTypeIDExceptBusyCage(cagetype.Id, petsize.IsSingle, CageCodesNotValid) >= CageAmount)
                                {
                                    Check = true;
                                    CageTypeCodeIsSelect.Add(cagetype.Id);
                                    break;
                                }
                            }
                        }

                        //If check here is null that 1 of those pet dont have cage in this center
                        if (!Check)
                        {
                            break;
                        }
                    }

                    if (Check)
                    {
                        validOCCenter.Add(center);
                    }
                }
                else
                {
                    foreach (var booking in BookingOfCenter)
                    {
                        //This code is get booking detail of all busy bookings in center
                        BookingDetails = _bookingDetailRepository.GetBookingDetailForSearch(booking.Id).ToList();
                        foreach (var bookingdetail in BookingDetails)
                        {
                            CageCodesNotValid.Add(bookingdetail.CageCode);
                        }
                    }
                    //Here is cage of the center is invalid time with booking
                    //CenterWithCage.Add(center.Id, CageCodesNotValid);
                    //Check center cagetype is valid size
                    //List<int> CageTypeValidCode = new List<int>();
                    var CageTypes = center.CageTypes;

                    //Check is fields that check center have any cage valid for pet
                    bool Check = false;
                    List<int> CageTypeCodeIsSelect = new List<int>();
                    foreach (var petsize in PetSizes)
                    {
                        foreach (var cagetype in CageTypes)
                        {
                            if (cagetype.Height >= petsize.Height && cagetype.Width >= petsize.Width)
                            {
                                //CageTypeValidCode.Add(cagetype.Id);
                                int CageAmount = 1;
                                int CageTypeCodeIsSelectAmount = CageTypeCodeIsSelect.Where(x => x == cagetype.Id).Count();
                                if (CageTypeCodeIsSelectAmount > 0)
                                {
                                    CageAmount += CageTypeCodeIsSelectAmount;
                                }
                                if (_cageRepository.CountCageByCageTypeIDExceptBusyCage(cagetype.Id, petsize.IsSingle, CageCodesNotValid) >= CageAmount)
                                {
                                    Check = true;
                                    CageTypeCodeIsSelect.Add(cagetype.Id);
                                    break;
                                }
                                else
                                {
                                    Check = false;
                                }
                            }
                            else
                            {
                                Check = false;
                            }
                        }

                        //If check here is null that 1 of those pet dont have cage in this center
                        if (!Check)
                        {
                            break;
                        }
                    }

                    if (Check)
                    {
                        validOCCenter.Add(center);
                    }
                }
            }
            //END Check valid cage for pet

            values = validOCCenter;

            values = values.Select(center => new PetCenter
            {
                Id = center.Id,
                Name = center.Name,
                Address = center.Address,
                Phone = center.Phone,
                Rating = center.Rating,
                CreateDate = center.CreateDate,
                Status = center.Status,
                OpenTime = center.OpenTime,
                CloseTime = center.CloseTime,
                Description = center.Description,
                BrandId = center.BrandId,
                EndBooking = center.EndBooking,
                Photos = center.Photos
            });

            return PagedList<PetCenter>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        public async Task<SearchPetCenterResponse> ReferenceCenter(string City, string District,
            string StartBooking, int Due,
            List<List<PetRequestForSearchCenter>> _petRequests, PagingParameter paging)
        {
            var values = MainSearchCenter_ver_2(City, District,
                                                StartBooking, Due,
                                                _petRequests, paging);

            SearchPetCenterResponse searchPetCenterResponse = new SearchPetCenterResponse();

            if (values.Count <= 0)
            {
                var city_code = _cityRepository.GetFirstOrDefault(x => x.Code.Equals(City)).Code;
                var originDis = _districtRepository.GetFirstOrDefault(x => x.Code.Equals(District));
                var districts = _districtRepository.GetAll(x => x.CityCode.Equals(city_code) && !x.Code.Equals(District));

                var client = new HttpClient();
                string url = "https://rsapi.goong.io/DistanceMatrix?origins=" + originDis.Latitude + "," + originDis.Longtitude + "&destinations=";


                var lastitem = districts.Last();
                foreach (var district in districts)
                {
                    if (district.Equals(lastitem))
                    {
                        url = url + district.Latitude + "," + district.Longtitude;
                    }
                    else
                    {
                        url = url + district.Latitude + "," + district.Longtitude + "%7C";
                    }
                }
                url = url + "&api_key=r81jNaUAOipzIiuOoPIN1S3m0vaURbdE2LldWk7z";

                HttpResponseMessage response = await client.GetAsync(url);
                response.EnsureSuccessStatusCode();

                var result = await response.Content.ReadAsStringAsync();
                var cust = JObject.Parse(result);

                var districtdistance = new Dictionary<District, int>();
                for (int i = 0; i < districts.LongCount() - 1; i++)
                {
                    var distance = cust["rows"][0]["elements"][i]["distance"]["value"].ToString();
                    districtdistance.Add(districts.ToList()[i], int.Parse(distance));
                }

                districtdistance = districtdistance.OrderBy(x => x.Value).ToDictionary(x => x.Key, x => x.Value);

                int count = 1;
                foreach (var item in districtdistance)
                {
                    if (count <= 3)
                    {
                        values = MainSearchCenter_ver_2(City, item.Key.Code,
                                                    StartBooking, Due,
                                                    _petRequests, paging);

                        count++;
                        if (values.Count > 0)
                        {

                            searchPetCenterResponse.City = City;
                            searchPetCenterResponse.District = item.Key.Code;
                            searchPetCenterResponse.DistrictName = item.Key.Name;
                            searchPetCenterResponse.petCenters = values;

                            return searchPetCenterResponse;
                        }
                    }
                }
            }

            searchPetCenterResponse.City = City;
            searchPetCenterResponse.District = District;
            searchPetCenterResponse.DistrictName = "";
            searchPetCenterResponse.petCenters = values;

            return searchPetCenterResponse;
        }

        //Search Center By Name
        public PagedList<PetCenter> SearchCenterByName(string Name, PagingParameter paging)
        {
            var values = _petCenterRepository.GetAll(x => x.Name.Contains(Name) && x.Status == true);

            return PagedList<PetCenter>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        //Check Center Is Avaliable With Request
        public PetCenter CheckCenter(int id, List<List<PetRequestParameter>> _petRequests, string StartBooking, int Due)
        {
            var value = _petCenterRepository.GetPetCenterByIdAfterSearchName(id);

            //--------------------------------------------------------------------------------------------
            //This is 24 Hours format
            if (StartBooking == null || Due <= 0)
            {
                throw new Exception("StartBooking is NULL");
            }
            DateTime _startBooking = DateTime.ParseExact(s: StartBooking, format: SearchConst.DateFormat,
                                                        CultureInfo.InvariantCulture);

            if (DateTime.Compare(_startBooking, DateTime.Now) <= 0)
            {
                throw new Exception("StartBooking is INVALID");
            }
            //END Check valid time booking

            foreach (var petIds in _petRequests)
            {
                foreach (var petId in petIds)
                {
                    if (_petBookingDetailRepository.GetAll(x => x.PetId == petId.Id &&
                            (DateTime.Compare(_startBooking, (DateTime)x.BookingDetail.Booking.StartBooking) >= 0
                            && DateTime.Compare(_startBooking, (DateTime)x.BookingDetail.Booking.EndBooking) < 0)).Count() != 0)
                    {
                        throw new Exception("Pet is Booking Already");
                    }
                }
            }

            string petCenterOpenTime = _petCenterRepository.GetFirstOrDefault(x => x.Id == value.Id).OpenTime;
            string petCenterCloseTime = _petCenterRepository.GetFirstOrDefault(x => x.Id == value.Id).CloseTime;

            //String format = petCenterOpenTime.Length == 5 ? "H\\:mm\\:ss" : "HH\\:mm\\:ss";

            TimeSpan _petCenterOpenTime = TimeSpan.ParseExact(input: petCenterOpenTime, format: SearchConst.TimeFormat,
                                                            CultureInfo.InvariantCulture);

            //format = petCenterCloseTime.Length == 5 ? "H\\:mm\\:ss" : "HH\\:mm\\:ss";

            TimeSpan _petCenterCloseTime = TimeSpan.ParseExact(input: petCenterCloseTime, format: SearchConst.TimeFormat,
                                                            CultureInfo.InvariantCulture);

            if (_petCenterOpenTime < _startBooking.TimeOfDay && _petCenterCloseTime > _startBooking.TimeOfDay)
            {

            }
            else
            {
                throw new Exception("StartBooking is INVALID");
            }

            //START Check Size of Pet
            List<PetSizeCage> PetSizes = new List<PetSizeCage>();

            foreach (var _petRequest in _petRequests)
            {
                int Count = 0;
                decimal Height = 0;
                decimal Width = 0;
                foreach (var _pet in _petRequest)
                {
                    if (Height < (decimal)(_pet.Height + SearchConst.HeightAdd))
                    {
                        Height = (decimal)(_pet.Height + SearchConst.HeightAdd);
                    }

                    Width += (decimal)Math.Round((((double)_pet.Length) + ((double)_pet.Height)) / SearchConst.WidthRatio, 0);
                    Count += 1;
                }

                PetSizeCage petSize = new PetSizeCage();
                petSize.Height = Height;
                petSize.Width = Width;
                if (Count > 1) petSize.IsSingle = false;
                PetSizes.Add(petSize);
            }
            //END Check Size of Pet

            //START Check valid cage for pet
            //Check free cage in time booking
            //Check amount of cage with amount of pet
            //Check size of cage with size of pet (merge with upper line)
            //Get cage code of center store to Map
            List<BookingDetail> BookingDetails = new List<BookingDetail>();
            List<string> CageCodesNotValid = new List<string>();
            Dictionary<int, List<string>> CenterWithCage = new Dictionary<int, List<string>>();

            TimeSpan diffOfDates = DateTime.Parse(value.Checkout.ToString()).TimeOfDay.Subtract(_startBooking.TimeOfDay);

            DateTime _endBooking = _startBooking.AddDays(Due).AddHours(diffOfDates.Hours);

            value.EndBooking = _endBooking;

            var BookingOfCenter = _bookingRepository.GetBookingValidSearch(value.Id, _startBooking, _endBooking);

            //If BookingOfCenter is null => That center have cage free for pet
            if (BookingOfCenter.Count() == 0)
            {
                var CageTypes = value.CageTypes;

                //Check is fields that check center have any cage valid for pet
                bool Check = false;
                List<int> CageTypeCodeIsSelect = new List<int>();
                foreach (var petsize in PetSizes)
                {
                    Check = false;

                    foreach (var cagetype in CageTypes)
                    {
                        if (cagetype.Height >= petsize.Height && cagetype.Width >= petsize.Width)
                        {
                            //CageTypeValidCode.Add(cagetype.Id);

                            int CageAmount = 1;
                            int CageTypeCodeIsSelectAmount = CageTypeCodeIsSelect.Where(x => x == cagetype.Id).Count();
                            if (CageTypeCodeIsSelectAmount > 0)
                            {
                                CageAmount += CageTypeCodeIsSelectAmount;
                            }
                            if (_cageRepository.CountCageByCageTypeIDExceptBusyCage(cagetype.Id, petsize.IsSingle, CageCodesNotValid) >= CageAmount)
                            {
                                Check = true;
                                CageTypeCodeIsSelect.Add(cagetype.Id);
                                break;
                            }
                        }
                    }

                    //If check here is null that 1 of those pet dont have cage in this center
                    if (!Check)
                    {
                        break;
                    }
                }

                if (Check)
                {
                }
                else
                {
                    throw new Exception("This center not avaliable with request");
                }
            }
            else
            {
                foreach (var booking in BookingOfCenter)
                {
                    //This code is get booking detail of all busy bookings in center
                    BookingDetails = _bookingDetailRepository.GetBookingDetailForSearch(booking.Id).ToList();
                    foreach (var bookingdetail in BookingDetails)
                    {
                        CageCodesNotValid.Add(bookingdetail.CageCode);
                    }
                }
                //Here is cage of the center is invalid time with booking
                //CenterWithCage.Add(center.Id, CageCodesNotValid);
                //Check center cagetype is valid size
                //List<int> CageTypeValidCode = new List<int>();
                var CageTypes = value.CageTypes;

                //Check is fields that check center have any cage valid for pet
                bool Check = false;
                List<int> CageTypeCodeIsSelect = new List<int>();
                foreach (var petsize in PetSizes)
                {
                    foreach (var cagetype in CageTypes)
                    {
                        if (cagetype.Height >= petsize.Height && cagetype.Width >= petsize.Width)
                        {
                            //CageTypeValidCode.Add(cagetype.Id);
                            int CageAmount = 1;
                            int CageTypeCodeIsSelectAmount = CageTypeCodeIsSelect.Where(x => x == cagetype.Id).Count();
                            if (CageTypeCodeIsSelectAmount > 0)
                            {
                                CageAmount += CageTypeCodeIsSelectAmount;
                            }
                            if (_cageRepository.CountCageByCageTypeIDExceptBusyCage(cagetype.Id, petsize.IsSingle, CageCodesNotValid) >= CageAmount)
                            {
                                Check = true;
                                CageTypeCodeIsSelect.Add(cagetype.Id);
                                break;
                            }
                            else
                            {
                                Check = false;
                            }
                        }
                        else
                        {
                            Check = false;
                        }
                    }

                    //If check here is null that 1 of those pet dont have cage in this center
                    if (!Check)
                    {
                        break;
                    }
                }

                if (Check)
                {
                }
                else
                {
                    throw new Exception("This center not avaliable with request");
                }
            }
            //End check cage in Center

            PetSizeCage petSizeCages = new PetSizeCage
            {
                Height = PetSizes.Min(x => x.Height),
                Width = PetSizes.Min(x => x.Width),
                IsSingle = true
            };

            try
            {
                var data = _petCenterRepository.GetPetCenterById(id, petSizeCages, StartBooking, value.EndBooking.ToString());

                return data;
            }
            catch
            {
                throw new Exception("Get Pet Center By Id Exception");
            }

        }
    }
}
