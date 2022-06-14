using Microsoft.EntityFrameworkCore;
using PawNClaw.Data.Const;
using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static PawNClaw.Data.Repository.PetCenterRepository;

namespace PawNClaw.Data.Repository
{
    public class CageTypeRepository : Repository<CageType>, ICageTypeRepository
    {

        PriceRepository _priceRepository;

        public CageTypeRepository(ApplicationDbContext db, PriceRepository priceRepository) : base(db)
        {
            _priceRepository = priceRepository;
        }

        public IEnumerable<CageType> GetAllCageWithCageType(int centerId)
        {
            IQueryable<CageType> query = _dbSet;

            query = query.Include("Cages")
                            .Include("Prices")
                            .Where(x => x.CenterId == centerId);

            return query.ToList();
        }

        public IEnumerable<CageType> GetCageTypeValidPetSizeAndBookingTime(int CenterId, List<PetRequestForSearchCenter> listPets, string StartBooking, string EndBooking)
        {
            DateTime _startBooking = DateTime.ParseExact(StartBooking, SearchConst.DateFormat,
                                       System.Globalization.CultureInfo.InvariantCulture);

            DateTime _endBooking = DateTime.ParseExact(EndBooking, SearchConst.DateFormat,
                                       System.Globalization.CultureInfo.InvariantCulture);

            int Count = 0;
            decimal Height = 0;
            decimal Width = 0;

            foreach (var pet in listPets)
            {
                if (Height < (decimal)(pet.Height + SearchConst.HeightAdd))
                {
                    Height = (decimal)(pet.Height + SearchConst.HeightAdd);
                }

                Width += (decimal)Math.Round((((double)pet.Length) + ((double)pet.Height)) / SearchConst.WidthRatio, 0);
                Count += 1;
            }

            PetSizeCage petSize = new PetSizeCage();
            petSize.Height = Height;
            petSize.Width = Width;
            if (Count > 1) petSize.IsSingle = false;

            IQueryable<CageType> query = _dbSet
            .Where(cagetype => cagetype.Height >= petSize.Height
                && cagetype.Width >= petSize.Width
                && cagetype.CenterId == CenterId
                && cagetype.IsSingle == petSize.IsSingle)
            .Include(catype => catype.Cages)
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
                TotalPrice = _priceRepository.checkTotalPriceOfCageType(cagetype.Id, StartBooking, EndBooking),
                Cages = (ICollection<Cage>)cagetype.Cages.Where(cage => !cage.BookingDetails.Any(bookingdetail =>
                        ((DateTime.Compare(_startBooking, (DateTime)bookingdetail.Booking.StartBooking) <= 0
                        && DateTime.Compare(_endBooking, (DateTime)bookingdetail.Booking.EndBooking) >= 0)
                        ||
                        (DateTime.Compare(_startBooking, (DateTime)bookingdetail.Booking.StartBooking) >= 0
                        && DateTime.Compare(_startBooking, (DateTime)bookingdetail.Booking.EndBooking) < 0)
                        ||
                        (DateTime.Compare(_endBooking, (DateTime)bookingdetail.Booking.StartBooking) > 0
                        && DateTime.Compare(_endBooking, (DateTime)bookingdetail.Booking.EndBooking) <= 0))))
            });


            List<CageType> cageTypes = new List<CageType>();
            foreach (var cageType in query)
            {
                if (cageType.Cages.Count > 0)
                {
                    cageTypes.Add(cageType);
                }
            }
            return cageTypes;
        }
    }
}
