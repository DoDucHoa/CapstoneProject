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

        public IEnumerable<CageType> GetCageTypeValidPetSizeAndBookingTime(List<List<CreatePetRequestParameter>> listPets, string StartBooking, string EndBooking)
        {
            DateTime _startBooking = DateTime.ParseExact(StartBooking, SearchConst.DateFormat,
                                       System.Globalization.CultureInfo.InvariantCulture);

            DateTime _endBooking = DateTime.ParseExact(EndBooking, SearchConst.DateFormat,
                                       System.Globalization.CultureInfo.InvariantCulture);


            List<PetSizeCage> PetSizes = new List<PetSizeCage>();

            foreach (var listPet in listPets)
            {
                int Count = 0;
                decimal Height = 0;
                decimal Width = 0;
                foreach (var pet in listPet)
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
                PetSizes.Add(petSize);
            }

            PetSizeCage petSizeCages = new PetSizeCage
            {
                Height = PetSizes.Min(x => x.Height),
                Width = PetSizes.Min(x => x.Width),
                IsSingle = true
            };

            IQueryable<CageType> query = _dbSet
                .Where(cagetype => cagetype.Height >= petSizeCages.Height && cagetype.Width >= petSizeCages.Width)
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
            return query.ToList();
        }
    }
}
