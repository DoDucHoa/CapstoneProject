using Microsoft.EntityFrameworkCore;
using PawNClaw.Data.Database;
using PawNClaw.Data.DataObject;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class PetCenterRepository : Repository<PetCenter>, IPetCenterRepository
    {
        public class PetSizeCage
        {
            public decimal Height { get; set; }
            public decimal Width { get; set; }
            public bool IsSingle { get; set; } = true;
        }

        private readonly ApplicationDbContext _db;

        public PetCenterRepository(ApplicationDbContext db) : base(db)
        {
            _db = db;
        }

        public IEnumerable<PetCenter> SearchPetCenter(string City, string District)
        {
            IQueryable<PetCenter> query = _dbSet;

            query = query.Include("Location").Include("CageTypes").Where(x => x.Location.CityCode.Trim().Equals(City)
                                            && x.Location.DistrictCode.Trim().Equals(District));

            return query.ToList();
        }

        public IEnumerable<PetCenter> SearchPetCenterQuery(string City, string District,
            string StartBooking, string EndBooking, List<PetSizeCage> PetSizes)
        {
            IQueryable<PetCenter> query = _dbSet;

            DateTime _startBooking = DateTime.ParseExact(StartBooking, "yyyy-MM-dd HH:mm:ss",
                                       System.Globalization.CultureInfo.InvariantCulture);

            DateTime _endBooking = DateTime.ParseExact(EndBooking, "yyyy-MM-dd HH:mm:ss",
                                       System.Globalization.CultureInfo.InvariantCulture);

            //Check Location
            //Check Open Time Close Time
            //Check Booking Is Busy
            query = query.Include("Location")
                .Include("CageTypes")
                .Include("Bookings")
                .Include("Cages")
                .Include("Bookings.BookingDetails")
                .Where(x => x.Location.CityCode.ToString().Trim().Equals(City)
                    && x.Location.DistrictCode.ToString().Trim().Equals(District)
                    && TimeSpan.ParseExact(x.OpenTime, "HH:mm:ss", System.Globalization.CultureInfo.InvariantCulture) < _startBooking.TimeOfDay
                    && TimeSpan.ParseExact(x.CloseTime, "HH:mm:ss", System.Globalization.CultureInfo.InvariantCulture) > _startBooking.TimeOfDay
                    && TimeSpan.ParseExact(x.OpenTime, "HH:mm:ss", System.Globalization.CultureInfo.InvariantCulture) < _endBooking.TimeOfDay
                    && TimeSpan.ParseExact(x.CloseTime, "HH:mm:ss", System.Globalization.CultureInfo.InvariantCulture) > _endBooking.TimeOfDay
                    && x.Bookings.Any(y => (y.StatusId == 1 || y.StatusId == 2 || y.StatusId == 3)
                                        && DateTime.Compare(_startBooking, (DateTime)y.StartBooking) <= 0
                                        && DateTime.Compare(_endBooking, (DateTime)y.EndBooking) >= 0));
            return query.ToList();
        }

        public IEnumerable<PetCenter> SearchPetCenterQueryNonBooking(string City, string District,
            string StartBooking, string EndBooking, List<PetSizeCage> PetSizes)
        {
            IQueryable<PetCenter> query = _dbSet;

            DateTime _startBooking = DateTime.ParseExact(StartBooking, "yyyy-MM-dd HH:mm:ss",
                                       System.Globalization.CultureInfo.InvariantCulture);

            DateTime _endBooking = DateTime.ParseExact(EndBooking, "yyyy-MM-dd HH:mm:ss",
                                       System.Globalization.CultureInfo.InvariantCulture);

            //Check Location
            //Check Open Time Close Time
            query = query.Include("Location")
                .Include("CageTypes")
                .Include("Bookings")
                .Include("Cages")
                .Include("Bookings.BookingDetails")
                .Where(x => x.Location.CityCode.ToString().Trim().Equals(City)
                    && x.Location.DistrictCode.ToString().Trim().Equals(District)
                    && TimeSpan.ParseExact(x.OpenTime, "HH:mm:ss", System.Globalization.CultureInfo.InvariantCulture) < _startBooking.TimeOfDay
                    && TimeSpan.ParseExact(x.CloseTime, "HH:mm:ss", System.Globalization.CultureInfo.InvariantCulture) > _startBooking.TimeOfDay
                    && TimeSpan.ParseExact(x.OpenTime, "HH:mm:ss", System.Globalization.CultureInfo.InvariantCulture) < _endBooking.TimeOfDay
                    && TimeSpan.ParseExact(x.CloseTime, "HH:mm:ss", System.Globalization.CultureInfo.InvariantCulture) > _endBooking.TimeOfDay);
            return query.ToList();
        }

        //Get Pet Center Detail
        public PetCenterData GetPetCenterById(int id, PetSizeCage PetSizes)
        {
            var center = _dbSet.Where(x => x.Id == id)
                .Include("Services")
                .Include("CageTypes")
                .Include("Supplies")
                .Include("Supplies.SupplyTypeCodeNavigation")
                .Include("CageTypes.Cages").FirstOrDefault();

            center.CageTypes = center.CageTypes.Where(x => x.Height >= PetSizes.Height && x.Width >= PetSizes.Width).ToList();
            center.Cages = null;

            PetCenterData petCenter = new PetCenterData
            {
                PetCenter = center
            };

            return petCenter;
        }
    }
}
