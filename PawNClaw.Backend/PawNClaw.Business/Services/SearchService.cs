using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using PawNClaw.Data.Const;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static PawNClaw.Data.Repository.PetCenterRepository;

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

        public SearchService(IPetCenterRepository petCenterRepository, ILocationRepository locationRepository,
            IBookingRepository bookingRepository, IBookingDetailRepository bookingDetailRepository,
            ICageRepository cageRepository, IPetBookingDetailRepository petBookingDetailRepository)
        {
            _petCenterRepository = petCenterRepository;
            _locationRepository = locationRepository;
            _bookingRepository = bookingRepository;
            _bookingDetailRepository = bookingDetailRepository;
            _cageRepository = cageRepository;
            _petBookingDetailRepository = petBookingDetailRepository;
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
                throw new Exception("StartBooking or EndBooking is NULL");
            }
            DateTime _startBooking = DateTime.ParseExact(s: StartBooking, format: SearchConst.DateFormat,
                                                        CultureInfo.InvariantCulture);

            if (DateTime.Compare(_startBooking, DateTime.Now) <= 0)
            {
                throw new Exception("StartBooking is INVALID");
            }
            //END Check valid time booking

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

                TimeSpan diffOfDates = _startBooking.TimeOfDay.Subtract(DateTime.Parse(center.Checkout.ToString()).TimeOfDay);

                DateTime _endBooking = _startBooking.AddDays(Due).AddHours(diffOfDates.Hours);

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
                BrandId = center.BrandId
            });



            return PagedList<PetCenter>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }
    }
}
