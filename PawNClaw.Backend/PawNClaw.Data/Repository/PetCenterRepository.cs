using Microsoft.EntityFrameworkCore;
using PawNClaw.Data.Const;
using PawNClaw.Data.Database;
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

        PriceRepository _priceRepository;
        public class CageUsed
        {
            string CageCode { get; set; }
            string CenterId { get; set; }
        }

        public class PetSizeCage
        {
            public decimal Height { get; set; }
            public decimal Width { get; set; }
            public bool IsSingle { get; set; } = true;
            public CageUsed CageUsed { get; set; }
        }

        public PetCenterRepository(ApplicationDbContext db, PriceRepository priceRepository) : base(db)
        {
            _priceRepository = priceRepository;
        }

        public IEnumerable<PetCenter> SearchPetCenter(string City, string District)
        {
            IQueryable<PetCenter> query = _dbSet;
            query = query.Include("Location").Include("CageTypes").Where(x => x.Location.CityCode.Trim().Equals(City)
                                            && x.Location.DistrictCode.Trim().Equals(District))
                .Select(x => new PetCenter
                {
                    Id = x.Id,
                    Name = x.Name,
                    Address = x.Address,
                    Phone = x.Phone,
                    Rating = x.Rating,
                    CreateDate = x.CreateDate,
                    Status = x.Status,
                    OpenTime = x.OpenTime,
                    CloseTime = x.CloseTime,
                    Description = x.Description,
                    BrandId = x.BrandId,
                    CageTypes = (ICollection<CageType>)x.CageTypes.Select(cagetype => new CageType
                    {
                        Id = cagetype.Id,
                        TypeName = cagetype.TypeName,
                        Description = cagetype.Description,
                        Height = cagetype.Height,
                        Width = cagetype.Width,
                        Length = cagetype.Length,
                        IsSingle = cagetype.IsSingle,
                        Status = cagetype.Status,
                        CenterId = cagetype.CenterId
                    })
                });
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
                    && x.Bookings.Any(y => (y.StatusId == 1 || y.StatusId == 2)
                                        && DateTime.Compare(_startBooking, (DateTime)y.StartBooking) <= 0
                                        && DateTime.Compare(_endBooking, (DateTime)y.EndBooking) >= 0));
            return query.ToList();
        }

        public IEnumerable<PetCenter> SearchPetCenterQueryNonBooking(string City, string District,
            string StartBooking, string EndBooking, List<PetSizeCage> PetSizes)
        {

            //Check Location
            //Check Open Time Close Time
            DateTime _startBooking = DateTime.ParseExact(StartBooking, SearchConst.DateFormat,
                                       System.Globalization.CultureInfo.InvariantCulture);

            DateTime _endBooking = DateTime.ParseExact(EndBooking, SearchConst.DateFormat,
                                       System.Globalization.CultureInfo.InvariantCulture);

            IQueryable<PetCenter> query = _dbSet.Include("Location")
                .Include(x => x.CageTypes)
                .Include(x => x.Bookings).ThenInclude(bookings => bookings.BookingDetails)
                .Include(x => x.Cages)
                .Where(x => x.Location.CityCode.ToString().Trim().Equals(City)
                    && x.Location.DistrictCode.ToString().Trim().Equals(District)
                    && TimeSpan.ParseExact(x.OpenTime, SearchConst.TimeFormat, System.Globalization.CultureInfo.InvariantCulture) < _startBooking.TimeOfDay
                    && TimeSpan.ParseExact(x.CloseTime, SearchConst.TimeFormat, System.Globalization.CultureInfo.InvariantCulture) > _startBooking.TimeOfDay
                    && TimeSpan.ParseExact(x.OpenTime, SearchConst.TimeFormat, System.Globalization.CultureInfo.InvariantCulture) < _endBooking.TimeOfDay
                    && TimeSpan.ParseExact(x.CloseTime, SearchConst.TimeFormat, System.Globalization.CultureInfo.InvariantCulture) > _endBooking.TimeOfDay);

            //Count cage in pet center is valid for pet request
            int Count = 0;
            foreach (var petSize in PetSizes)
            {
                Count++;
                query = query.Select(x => new PetCenter
                {
                    Id = x.Id,
                    Name = x.Name,
                    Address = x.Address,
                    Phone = x.Phone,
                    Rating = x.Rating,
                    CreateDate = x.CreateDate,
                    Status = x.Status,
                    OpenTime = x.OpenTime,
                    CloseTime = x.CloseTime,
                    Description = x.Description,
                    BrandId = x.BrandId,
                    CageTypes = (ICollection<CageType>)x.CageTypes
                    .Where(cageType => cageType.Height >= petSize.Height && cageType.Width >= petSize.Width
                        && cageType.IsSingle == petSize.IsSingle)
                    .Select(cagetype => cagetype.Cages
                            .Where(cage => cage.IsOnline == true && cage.Status == true)
                            .Select(cage => cage.BookingDetails
                                    .Where(bookingdetail => (bookingdetail.Booking.StatusId == 1
                                        || bookingdetail.Booking.StatusId == 2)
                                        && (DateTime.Compare(_startBooking, (DateTime)bookingdetail.Booking.EndBooking) >= 0
                                        || DateTime.Compare(_endBooking, (DateTime)bookingdetail.Booking.StartBooking) <= 0)))
                     .Count() >= Count)
                });


            }
            return query.ToList();
        }

        //Get Pet Center Detail
        public PetCenter GetPetCenterById(int id, PetSizeCage PetSizes, string StartBooking, string EndBooking)
        {
            var center = _dbSet
                .Include(x => x.Services)
                .Include(x => x.CageTypes)
                .ThenInclude(cagetype => cagetype.Cages)
                .Include(x => x.CageTypes)
                .ThenInclude(cagetype => cagetype.Prices)
                .Include(x => x.Supplies)
                .ThenInclude(supplies => supplies.SupplyTypeCodeNavigation)
                .Select(x => new PetCenter
                {
                    Id = x.Id,
                    Name = x.Name,
                    Address = x.Address,
                    Phone = x.Phone,
                    Rating = x.Rating,
                    CreateDate = x.CreateDate,
                    Status = x.Status,
                    OpenTime = x.OpenTime,
                    CloseTime = x.CloseTime,
                    Description = x.Description,
                    BrandId = x.BrandId,
                    CageTypes = (ICollection<CageType>)x.CageTypes.Where(cagetype => cagetype.Height >= PetSizes.Height && cagetype.Width >= PetSizes.Width)
                    .Select(cagetype => new CageType
                    {
                        Id = cagetype.Id,
                        TypeName = cagetype.TypeName,
                        Description = cagetype.Description,
                        Height = cagetype.Height,
                        Width = cagetype.Width,
                        Length = cagetype.Length,
                        IsSingle = cagetype.IsSingle,
                        Status = cagetype.Status,
                        CenterId = cagetype.CenterId,
                        TotalPrice = _priceRepository.checkTotalPriceOfCageType(cagetype.Id, StartBooking, EndBooking)
                    }),
                    Supplies = (ICollection<Supply>)x.Supplies.Where(s => s.Quantity > 0 && s.Status == true)
                    .Select(s => new Supply
                    {
                        Id = s.Id,
                        Name = s.Name,
                        SellPrice = s.SellPrice,
                        DiscountPrice = s.DiscountPrice,
                        Quantity = s.Quantity,
                        SupplyTypeCodeNavigation = s.SupplyTypeCodeNavigation
                    }),
                    Services = (ICollection<Service>)x.Services.Where(ser => ser.Status == true)
                })
                .SingleOrDefault(x => x.Id == id);

            return center;
        }

        public string checkTotalPriceOfCageType(string StartBooking, string EndBooking)
        {
            DateTime _startBooking = DateTime.ParseExact(StartBooking, SearchConst.DateFormat,
                                       System.Globalization.CultureInfo.InvariantCulture);

            DateTime _endBooking = DateTime.ParseExact(EndBooking, SearchConst.DateFormat,
                                       System.Globalization.CultureInfo.InvariantCulture);

            DateTime _aStarBooking = _startBooking.AddDays(1);
            DateTime _bEndBooking = _endBooking.AddDays(-1);

            Console.WriteLine("***********************************");
            Console.WriteLine(_startBooking);
            Console.WriteLine(_aStarBooking.TimeOfDay);
            Console.WriteLine(_bEndBooking.Date);

            try
            {
                for (var dt = _aStarBooking; dt.Date <= _bEndBooking.Date; dt = dt.AddDays(1))
                {

                    Console.WriteLine(dt.Date);
                    Console.WriteLine(dt.DayOfWeek);
                }
            }
            catch
            {
                throw new Exception();
            }

            return null;
        }
    }
}
