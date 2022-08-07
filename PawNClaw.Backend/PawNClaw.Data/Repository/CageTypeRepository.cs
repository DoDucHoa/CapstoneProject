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
        IPhotoRepository _photoRepository;

        public CageTypeRepository(ApplicationDbContext db, PriceRepository priceRepository, IPhotoRepository photoRepository) : base(db)
        {
            _priceRepository = priceRepository;
            _photoRepository = photoRepository;
        }

        public IEnumerable<CageType> GetAllCageWithCageType(int centerId)
        {
            IQueryable<CageType> query = _dbSet;

            query = query
                .Include("Cages")
                .Include("Prices")
                .Select(x => new CageType {
                    Id = x.Id,
                    TypeName = x.TypeName,
                    Description = x.Description,
                    Height = x.Height,
                    Width = x.Width,
                    Length = x.Length,
                    IsSingle = x.IsSingle,
                    CreateDate = x.CreateDate,
                    CreateUser = x.CreateUser,
                    ModifyDate = x.ModifyDate,
                    ModifyUser = x.ModifyUser,
                    Status = x.Status,
                    CenterId = x.CenterId,
                    Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(x.Id, PhotoTypesConst.CageType),
                    Prices = x.Prices
                })
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
            petSize.IsSingle = true;
            if (Count > 1) petSize.IsSingle = false;

            IQueryable<CageType> query;

            if (!petSize.IsSingle)
            {
                query = _dbSet
            .Where(cagetype => cagetype.Height >= petSize.Height
                && cagetype.Width >= petSize.Width
                && cagetype.CenterId == CenterId
                && cagetype.IsSingle == petSize.IsSingle
                && cagetype.Status == true)
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
                Cages = (ICollection<Cage>)cagetype.Cages.Where(cage => cage.Status == true && cage.IsOnline == true
                        && !cage.BookingDetails.Any(bookingdetail =>
                        ((DateTime.Compare(_startBooking, (DateTime)bookingdetail.Booking.StartBooking) <= 0
                        && DateTime.Compare(_endBooking, (DateTime)bookingdetail.Booking.EndBooking) >= 0)
                        ||
                        (DateTime.Compare(_startBooking, (DateTime)bookingdetail.Booking.StartBooking) >= 0
                        && DateTime.Compare(_startBooking, (DateTime)bookingdetail.Booking.EndBooking) < 0)
                        ||
                        (DateTime.Compare(_endBooking, (DateTime)bookingdetail.Booking.StartBooking) > 0
                        && DateTime.Compare(_endBooking, (DateTime)bookingdetail.Booking.EndBooking) <= 0))
                        && (bookingdetail.Booking.StatusId == 1 || bookingdetail.Booking.StatusId == 2)))
            });
            }
            else
            {
                query = _dbSet
            .Where(cagetype => cagetype.Height >= petSize.Height
                && cagetype.Width >= petSize.Width
                && cagetype.CenterId == CenterId
                && cagetype.Status == true)
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
                Cages = (ICollection<Cage>)cagetype.Cages.Where(cage => cage.Status == true && cage.IsOnline == true
                        && !cage.BookingDetails.Any(bookingdetail =>
                        ((DateTime.Compare(_startBooking, (DateTime)bookingdetail.Booking.StartBooking) <= 0
                        && DateTime.Compare(_endBooking, (DateTime)bookingdetail.Booking.EndBooking) >= 0)
                        ||
                        (DateTime.Compare(_startBooking, (DateTime)bookingdetail.Booking.StartBooking) >= 0
                        && DateTime.Compare(_startBooking, (DateTime)bookingdetail.Booking.EndBooking) < 0)
                        ||
                        (DateTime.Compare(_endBooking, (DateTime)bookingdetail.Booking.StartBooking) > 0
                        && DateTime.Compare(_endBooking, (DateTime)bookingdetail.Booking.EndBooking) <= 0))
                        && (bookingdetail.Booking.StatusId == 1 || bookingdetail.Booking.StatusId == 2)))
            });
            }

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

        public CageType GetCageTypeWithCageAndPrice(int id)
        {
            CageType query = _dbSet.Include(x => x.Cages)
                .ThenInclude(y => y.BookingDetails)
                .ThenInclude(z => z.Booking)
                .Include(x => x.Prices)
                .Include(x => x.FoodSchedules)
                .Select(x => new CageType
                {
                    Id = x.Id,
                    TypeName = x.TypeName,
                    Description = x.Description,
                    Height = x.Height,
                    Width = x.Width,
                    Length = x.Length,
                    IsSingle = x.IsSingle,
                    CreateDate = x.CreateDate,
                    CreateUser = x.CreateUser,
                    ModifyDate = x.ModifyDate,
                    ModifyUser = x.ModifyUser,
                    Status = x.Status,
                    CenterId = x.CenterId,
                    Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(x.Id, PhotoTypesConst.CageType),
                    Prices = x.Prices,
                    Cages = (ICollection<Cage>)x.Cages.Select(cage => new Cage { 
                        Code = cage.Code,
                        CenterId = cage.CenterId,
                        Name = cage.Name,
                        Color = cage.Color,
                        IsOnline = cage.IsOnline,
                        CreateDate = cage.CreateDate,
                        ModifyDate = cage.ModifyDate,
                        CreateUser = cage.CreateUser,
                        ModifyUser = cage.ModifyUser,
                        Status = cage.Status,
                        CageTypeId = cage.CageTypeId,
                        BookingDetails = (ICollection<BookingDetail>)cage.BookingDetails.Select(bookdetail => new BookingDetail { 
                            Id = bookdetail.Id,
                            BookingId = bookdetail.BookingId,
                            Price = bookdetail.Price,
                            CageCode = bookdetail.CageCode,
                            CenterId = bookdetail.CenterId,
                            Duration = bookdetail.Duration,
                            Note = bookdetail.Note,
                            Booking = bookdetail.Booking
                        })
                    }),
                    FoodSchedules = x.FoodSchedules
                })
                .Where(x => x.Id == id).FirstOrDefault();

            return query;
        }
    }
}
