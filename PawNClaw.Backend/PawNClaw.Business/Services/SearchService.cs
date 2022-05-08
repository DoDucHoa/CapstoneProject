using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class SearchService
    {
        class PetSizeCage
        {
            public decimal Height { get; set; }
            public decimal Width { get; set; }
        }

        IPetCenterRepository _petCenterRepository;
        IBookingRepository _bookingRepository;
        ILocationRepository _locationRepository;

        public SearchService(IPetCenterRepository petCenterRepository, ILocationRepository locationRepository,
            IBookingRepository bookingRepository)
        {
            _petCenterRepository = petCenterRepository;
            _locationRepository = locationRepository;
            _bookingRepository = bookingRepository;
        }

        public PagedList<PetCenter> GetAccounts(string City, string District,
            string StartBooking, string EndBooking,
            List<PetRequestParameter> _petRequests, PagingParameter paging)
        {
            //Check loaction
            var values = _petCenterRepository.SearchPetCenter(City, District);

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
            foreach (var center in values)
            {
                string petCenterOpenTime = _petCenterRepository.GetFirstOrDefault(x => x.Id == center.Id).OpenTime;
                string petCenterCloseTime = _petCenterRepository.GetFirstOrDefault(x => x.Id == center.Id).CloseTime;

                TimeSpan _petCenterOpenTime = TimeSpan.ParseExact(petCenterOpenTime, "HH:mm:ss",
                                       System.Globalization.CultureInfo.InvariantCulture);

                TimeSpan _petCenterCloseTime = TimeSpan.ParseExact(petCenterCloseTime, "HH:mm:ss",
                                           System.Globalization.CultureInfo.InvariantCulture);

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
            List<PetSizeCage> PetSize = new List<PetSizeCage>();

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

                PetSize.Add(petSize);
            }
            //END Check Size of Pet

            //START Check valid cage for pet
            //Check free cage in time booking
            //Check amount of cage with amount of pet
            //Check size of cage with size of pet (merge with upper line)
            foreach (var center in values)
            {
                var BookingOfCenter = _bookingRepository.GetBookingValidSearch(center.Id, _startBooking, _endBooking);


            }

            return PagedList<PetCenter>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }
    }
}
