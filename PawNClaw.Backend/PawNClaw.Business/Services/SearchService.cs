using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
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
        private const string TimeFormat = @"hh\:mm";
        private const string DateFormat = "yyyy-MM-dd HH:mm:ss";
        IPetCenterRepository _petCenterRepository;
        IBookingRepository _bookingRepository;
        IBookingDetailRepository _bookingDetailRepository;
        ICageRepository _cageRepository;
        ILocationRepository _locationRepository;

        public SearchService(IPetCenterRepository petCenterRepository, ILocationRepository locationRepository,
            IBookingRepository bookingRepository, IBookingDetailRepository bookingDetailRepository,
            ICageRepository cageRepository)
        {
            _petCenterRepository = petCenterRepository;
            _locationRepository = locationRepository;
            _bookingRepository = bookingRepository;
            _bookingDetailRepository = bookingDetailRepository;
            _cageRepository = cageRepository;
        }

        public PagedList<PetCenter> MainSearchCenter(string City, string District,
            string StartBooking, string EndBooking,
            List<List<PetRequestParameter>> _petRequests, PagingParameter paging)
        {
            //Check loaction
            var values = _petCenterRepository.SearchPetCenter(City, District);

            //START Check valid time booking
            //This is 24 Hours format
            if (StartBooking == null || EndBooking == null)
            {
                throw new Exception();
            }
            DateTime _startBooking = DateTime.ParseExact(s: StartBooking, format: DateFormat,
                                                        CultureInfo.InvariantCulture);

            DateTime _endBooking = DateTime.ParseExact(s: EndBooking, format: DateFormat,
                                                        CultureInfo.InvariantCulture);
            if (DateTime.Compare(_startBooking, DateTime.Now) <= 0 || DateTime.Compare(_startBooking, _endBooking) >= 0)
            {
                throw new Exception();
            }
            //END Check valid time booking

            //START Check time booking with open close time from petcenter
            List<PetCenter> validOCCenter = new List<PetCenter>();
            foreach (var center in values)
            {
                string petCenterOpenTime = _petCenterRepository.GetFirstOrDefault(x => x.Id == center.Id).OpenTime;
                string petCenterCloseTime = _petCenterRepository.GetFirstOrDefault(x => x.Id == center.Id).CloseTime;

                //String format = petCenterOpenTime.Length == 5 ? "H\\:mm\\:ss" : "HH\\:mm\\:ss";

                TimeSpan _petCenterOpenTime = TimeSpan.ParseExact(input: petCenterOpenTime, format: TimeFormat,
                                                                CultureInfo.InvariantCulture);

                //format = petCenterCloseTime.Length == 5 ? "H\\:mm\\:ss" : "HH\\:mm\\:ss";

                TimeSpan _petCenterCloseTime = TimeSpan.ParseExact(input: petCenterCloseTime, format: TimeFormat,
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
                    if (_pet.Height == null || _pet.Length == null || _pet.Weight == null)
                    {
                        throw new Exception();
                    }
                    if (Height < (decimal)(_pet.Height + 5))
                    {
                        Height = (decimal)(_pet.Height + 5);
                    }
                    
                    Width += (decimal)Math.Round((((double)_pet.Length) + ((double)_pet.Height)) / (5 / 2), 0);
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
                    
                    Console.WriteLine(center.Id + " Is Null");
                    //Check is fields that check center have any cage valid for pet
                    bool Check = true;
                    List<int> CageTypeCodeIsSelect = new List<int>();
                    foreach (var petsize in PetSizes)
                    {
                        Console.WriteLine(center.Id + " Pet H: " + petsize.Height);
                        Console.WriteLine(center.Id + " Pet W: " + petsize.Width);
                        foreach (var cagetype in CageTypes)
                        {
                            if (cagetype.Height >= petsize.Height && cagetype.Width >= petsize.Width)
                            {
                                //CageTypeValidCode.Add(cagetype.Id);

                                Console.WriteLine(center.Id + "Check Amount");

                                int CageAmount = 1;
                                int CageTypeCodeIsSelectAmount = CageTypeCodeIsSelect.Where(x => x == cagetype.Id).Count();
                                if (CageTypeCodeIsSelectAmount > 0)
                                {
                                    CageAmount += CageTypeCodeIsSelectAmount;
                                }
                                if (_cageRepository.CountCageByCageTypeIDExceptBusyCage(cagetype.Id, petsize.IsSingle, CageCodesNotValid) >= CageAmount)
                                {
                                    Check = true;
                                    Console.WriteLine(center.Id + " CageWithTypeID: " + cagetype.Id);
                                    CageTypeCodeIsSelect.Add(cagetype.Id);
                                    break;
                                }
                                else
                                {
                                    Check = false;
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
                    bool Check = true;
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
                            } else
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

            foreach (var item in values)
            {
                Console.WriteLine("Center is valid: " + item.Id);
            }

            return PagedList<PetCenter>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        //Main Search Function Ver 2
        public PagedList<PetCenter> MainSearchCenter_2(string City, string District,
            string StartBooking, string EndBooking,
            List<PetRequestParameter> _petRequests, PagingParameter paging)
        {
            //START Check valid time booking
            //This is 24 Hours format
            if (StartBooking == null || EndBooking == null)
            {
                throw new Exception();
            }
            DateTime _startBooking = DateTime.ParseExact(StartBooking, "yyyy-MM-dd HH:mm:ss",
                                       System.Globalization.CultureInfo.InvariantCulture);

            DateTime _endBooking = DateTime.ParseExact(EndBooking, "yyyy-MM-dd HH:mm:ss",
                                       System.Globalization.CultureInfo.InvariantCulture);
            if (DateTime.Compare(_startBooking, DateTime.Now) <= 0 || DateTime.Compare(_startBooking, _endBooking) >= 0)
            {
                throw new Exception();
            }
            //END Check valid time booking

            //START Check time booking with open close time from petcenter
            List<PetCenter> validOCCenter = new List<PetCenter>();
            //END Check time booking with open close time from petcenter
            //START Check Size of Pet
            List<PetSizeCage> PetSizes = new List<PetSizeCage>();

            foreach (var _petRequest in _petRequests)
            {
                if (_petRequest.Height == null || _petRequest.Length == null || _petRequest.Weight == null)
                {
                    throw new Exception();
                }
                decimal Height = (decimal)(_petRequest.Height + 5);
                decimal Width = (decimal)Math.Round((((double)_petRequest.Length) + ((double)_petRequest.Height)) / (5 / 2), 0);

                PetSizeCage petSize = new PetSizeCage();
                petSize.Height = Height;
                petSize.Width = Width;

                PetSizes.Add(petSize);
            }
            //END Check Size of Pet


            //START Check booking
            List<BookingDetail> BookingDetails = new List<BookingDetail>();
            List<string> CageCodesNotValid = new List<string>();
            Dictionary<int, List<string>> CenterWithCage = new Dictionary<int, List<string>>();

            var values = _petCenterRepository.SearchPetCenterQuery(City, District, StartBooking, EndBooking, PetSizes);

            if (values == null)
            {
                values = _petCenterRepository.SearchPetCenterQueryNonBooking(City, District, StartBooking, EndBooking, PetSizes);
            }
            else
            {
                //Stuck
                foreach (var center in values)
                {
                    var bookings = center.Bookings;
                }

            }

            //START Check valid cage for pet
            //Check free cage in time booking
            //Check amount of cage with amount of pet
            //Check size of cage with size of pet (merge with upper line)
            //Get cage code of center store to Map
            //List<BookingDetail> BookingDetails = new List<BookingDetail>();
            //List<string> CageCodesNotValid = new List<string>();
            //Dictionary<int, List<string>> CenterWithCage = new Dictionary<int, List<string>>();

            foreach (var center in values)
            {
                var BookingOfCenter = _bookingRepository.GetBookingValidSearch(center.Id, _startBooking, _endBooking);

                //If BookingOfCenter is null => That center have cage free for pet
                if (BookingOfCenter == null)
                {
                    var CageTypes = center.CageTypes;

                    //Check is fields that check center have any cage valid for pet
                    bool Check = true;
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
                    bool Check = true;
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
                            } else
                            {
                                Check = false;
                            }
                        }

                        //If check here is null that 1 of those pet dont have cage in this center
                        if (Check == false)
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

            return PagedList<PetCenter>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        public List<PetSizeCage> TestListParameter(List<List<PetRequestParameter>> _petRequests)
        {
            List<PetSizeCage> PetSizes = new List<PetSizeCage>();

            foreach (var _petRequest in _petRequests)
            {
                decimal Height = 0;
                decimal Width = 0;
                foreach (var _pet in _petRequest)
                {
                    if (_pet.Height == null || _pet.Length == null || _pet.Weight == null)
                    {
                        throw new Exception();
                    }

                    Height += (decimal)(_pet.Height + 5);
                    Width += (decimal)Math.Round((((double)_pet.Length) + ((double)_pet.Height)) / (5 / 2), 0);
                }

                PetSizeCage petSize = new PetSizeCage();
                petSize.Height = Height;
                petSize.Width = Width;

                PetSizes.Add(petSize);
            }

            return PetSizes;
        }
    }
}
