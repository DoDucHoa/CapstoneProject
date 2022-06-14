using Microsoft.EntityFrameworkCore;
using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class BookingRepository : Repository<Booking>, IBookingRepository
    {
        private readonly ApplicationDbContext _db;

        public BookingRepository(ApplicationDbContext db) : base(db)
        {
            _db = db;
        }

        public IEnumerable<Booking> GetBookingValidSearch(int Id, DateTime _startBooking, DateTime _endBooking)
        {
            IQueryable<Booking> query = _dbSet;

            query = query.Where(x => x.CenterId == Id && (x.StatusId == 1 || x.StatusId == 2)
            && !(DateTime.Compare(_startBooking, (DateTime)x.EndBooking) >= 0
            || DateTime.Compare(_endBooking, (DateTime)x.StartBooking) <= 0));

            return query.ToList();
        }

        public bool Confirm(int Id, int StatusId)
        {
            Booking query = _dbSet.FirstOrDefault(x => x.Id == Id);
            query.StatusId = StatusId;
            _dbSet.Update(query);
            return (_db.SaveChanges() >= 0);
        }

        public IEnumerable<Booking> GetBookingForStaff(BookingRequestParameter bookingRequestParameter)
        {
            IQueryable<Booking> query = _dbSet;

            if (bookingRequestParameter.Id.HasValue)
            {
                query = query.Where(x => x.Id == bookingRequestParameter.Id);
            }
            if (bookingRequestParameter.CenterId.HasValue)
            {
                query = query.Where(x => x.CenterId == bookingRequestParameter.CenterId);
            }
            if (bookingRequestParameter.CustomerId.HasValue)
            {
                query = query.Where(x => x.CustomerId == bookingRequestParameter.CustomerId);
            }
            if (bookingRequestParameter.StatusId.HasValue)
            {
                query = query.Where(x => x.StatusId == bookingRequestParameter.StatusId);
            }
            if (bookingRequestParameter.Year.HasValue)
            {
                query = query.Where(x => x.StartBooking.Value.Year == bookingRequestParameter.Year
                                && x.EndBooking.Value.Year == bookingRequestParameter.Year);
            }
            if (bookingRequestParameter.Month.HasValue)
            {
                query = query.Where(x => x.StartBooking.Value.Month == bookingRequestParameter.Month
                                && x.EndBooking.Value.Month == bookingRequestParameter.Month);
            }

            if (bookingRequestParameter.dir == "asc")
                query = query.OrderBy(d => d.CreateTime);
            else if (bookingRequestParameter.dir == "desc")
                query = query.OrderByDescending(d => d.CreateTime);

            query = query
                .Include(x => x.Customer)
                .Select(x => new Booking
                {
                    Id = x.Id,
                    StartBooking = x.StartBooking,
                    EndBooking = x.EndBooking,
                    StatusId = x.StatusId,
                    Customer = x.Customer
                });

            return query.ToList();
        }

        public Booking GetBookingForCustomer(int BookingId)
        {
            Booking query = _dbSet
                .Select(x => new Booking
                {
                    Id = x.Id,
                    CreateTime = x.CreateTime,
                    StartBooking = x.StartBooking,
                    EndBooking = x.EndBooking,
                    CheckIn = x.CheckIn,
                    CheckOut = x.CheckOut,
                    SubTotal = x.SubTotal,
                    Discount = x.Discount,
                    Total = x.Total,
                    StatusId = x.StatusId,
                    VoucherCode = x.VoucherCode,
                    CustomerId = x.CustomerId,
                    CenterId = x.CenterId,
                    Rating = x.Rating,
                    CustomerNote = x.CustomerNote,
                    StaffNote = x.StaffNote,
                    BookingDetails = (ICollection<BookingDetail>)x.BookingDetails
                    .Select(bookingdetail => new BookingDetail
                    {
                        BookingId = bookingdetail.BookingId,
                        Line = bookingdetail.Line,
                        Price = bookingdetail.Price,
                        CageCode = bookingdetail.CageCode,
                        CenterId = bookingdetail.CenterId,
                        Duration = bookingdetail.Duration,
                        Note = bookingdetail.Note,
                        PetBookingDetails = (ICollection<PetBookingDetail>)bookingdetail.PetBookingDetails
                        .Select(pet => new PetBookingDetail
                        {
                            BookingId = pet.BookingId,
                            Line = pet.Line,
                            Pet = new Pet
                            {
                                Id = pet.Pet.Id,
                                Name = pet.Pet.Name,
                                Height = pet.Pet.Height,
                                Length = pet.Pet.Length,
                                Weight = pet.Pet.Weight,
                                Birth = pet.Pet.Birth,
                                BreedName = pet.Pet.BreedName,
                                PetHealthHistories = (ICollection<PetHealthHistory>)pet.Pet.PetHealthHistories.Where(pethealth => pethealth.BookingId == BookingId)
                            }
                        })
                    }),
                    SupplyOrders = (ICollection<SupplyOrder>)x.SupplyOrders
                    .Select(supplyorder => new SupplyOrder
                    {
                        SupplyId = supplyorder.SupplyId,
                        BookingId = supplyorder.BookingId,
                        Quantity = supplyorder.Quantity,
                        SellPrice = supplyorder.SellPrice,
                        TotalPrice = supplyorder.TotalPrice,
                        Note = supplyorder.Note,
                        PetId = supplyorder.PetId,
                        Supply = supplyorder.Supply,
                        Pet = new Pet
                        {
                            Name = supplyorder.Pet.Name,
                        }
                    }),
                    ServiceOrders = (ICollection<ServiceOrder>)x.ServiceOrders
                    .Select(serviceorder => new ServiceOrder
                    {
                        ServiceId = serviceorder.ServiceId,
                        BookingId = serviceorder.BookingId,
                        Quantity = serviceorder.Quantity,
                        SellPrice = serviceorder.SellPrice,
                        TotalPrice = serviceorder.TotalPrice,
                        Note = serviceorder.Note,
                        PetId = serviceorder.PetId,
                        Service = serviceorder.Service,
                        Pet = new Pet
                        {
                            Name = serviceorder.Pet.Name,
                        }
                    }),
                    Customer = new Customer
                    {
                        Name = x.Customer.Name
                    },
                    Status = new BookingStatus
                    {
                        Name = x.Status.Name
                    }
                })
                .SingleOrDefault(x => x.Id == BookingId);

            return query;
        }

        public Booking GetBookingForStaff(int BookingId)
        {
            Booking query = _dbSet
                .Select(x => new Booking
                {
                    Id = x.Id,
                    CreateTime = x.CreateTime,
                    StartBooking = x.StartBooking,
                    EndBooking = x.EndBooking,
                    CheckIn = x.CheckIn,
                    CheckOut = x.CheckOut,
                    SubTotal = x.SubTotal,
                    Discount = x.Discount,
                    Total = x.Total,
                    StatusId = x.StatusId,
                    VoucherCode = x.VoucherCode,
                    CustomerId = x.CustomerId,
                    CenterId = x.CenterId,
                    Rating = x.Rating,
                    CustomerNote = x.CustomerNote,
                    StaffNote = x.StaffNote,
                    BookingDetails = (ICollection<BookingDetail>)x.BookingDetails
                    .Select(bookingdetail => new BookingDetail
                    {
                        BookingId = bookingdetail.BookingId,
                        Line = bookingdetail.Line,
                        Price = bookingdetail.Price,
                        CageCode = bookingdetail.CageCode,
                        CenterId = bookingdetail.CenterId,
                        Duration = bookingdetail.Duration,
                        Note = bookingdetail.Note,
                        PetBookingDetails = (ICollection<PetBookingDetail>)bookingdetail.PetBookingDetails
                        .Select(pet => new PetBookingDetail
                        {
                            BookingId = pet.BookingId,
                            Line = pet.Line,
                            Pet = new Pet
                            {
                                Id = pet.Pet.Id,
                                Name = pet.Pet.Name,
                                Height = pet.Pet.Height,
                                Length = pet.Pet.Length,
                                Weight = pet.Pet.Weight,
                                Birth = pet.Pet.Birth,
                                BreedName = pet.Pet.BreedName,
                                PetHealthHistories = (ICollection<PetHealthHistory>)pet.Pet.PetHealthHistories.Where(pethealth => pethealth.BookingId == BookingId)
                            }
                        })
                    }),
                    SupplyOrders = (ICollection<SupplyOrder>)x.SupplyOrders
                    .Select(supplyorder => new SupplyOrder
                    {
                        SupplyId = supplyorder.SupplyId,
                        BookingId = supplyorder.BookingId,
                        Quantity = supplyorder.Quantity,
                        SellPrice = supplyorder.SellPrice,
                        TotalPrice = supplyorder.TotalPrice,
                        Note = supplyorder.Note,
                        PetId = supplyorder.PetId,
                        Supply = supplyorder.Supply,
                        Pet = new Pet
                        {
                            Name = supplyorder.Pet.Name,
                        }
                    }),
                    ServiceOrders = (ICollection<ServiceOrder>)x.ServiceOrders
                    .Select(serviceorder => new ServiceOrder
                    {
                        ServiceId = serviceorder.ServiceId,
                        BookingId = serviceorder.BookingId,
                        Quantity = serviceorder.Quantity,
                        SellPrice = serviceorder.SellPrice,
                        TotalPrice = serviceorder.TotalPrice,
                        Note = serviceorder.Note,
                        PetId = serviceorder.PetId,
                        Service = serviceorder.Service,
                        Pet = new Pet
                        {
                            Name = serviceorder.Pet.Name,
                        }
                    }),
                    Customer = new Customer
                    {
                        Name = x.Customer.Name
                    }
                })
                .SingleOrDefault(x => x.Id == BookingId);

            return query;
        }

        public IEnumerable<Booking> GetBookingByCenterIdForStaff(int CenterId, int? StatusId)
        {
            IQueryable<Booking> query = _dbSet
                .Select(x => new Booking
                {
                    Id = x.Id,
                    CreateTime = x.CreateTime,
                    StartBooking = x.StartBooking,
                    EndBooking = x.EndBooking,
                    CheckIn = x.CheckIn,
                    CheckOut = x.CheckOut,
                    SubTotal = x.SubTotal,
                    Discount = x.Discount,
                    Total = x.Total,
                    StatusId = x.StatusId,
                    VoucherCode = x.VoucherCode,
                    CustomerId = x.CustomerId,
                    CenterId = x.CenterId,
                    Rating = x.Rating,
                    CustomerNote = x.CustomerNote,
                    StaffNote = x.StaffNote,
                    Customer = x.Customer
                })
                .Where(x => x.CenterId == CenterId);

            if (StatusId != null)
                query = query.Where(x => x.StatusId == StatusId);

            return query.ToList();
        }

        public IEnumerable<Booking> GetBookingByCustomerId(int CustomerId, int? StatusId)
        {
            IQueryable<Booking> query = _dbSet
                .Select(x => new Booking
                {
                    Id = x.Id,
                    CreateTime = x.CreateTime,
                    StartBooking = x.StartBooking,
                    EndBooking = x.EndBooking,
                    CheckIn = x.CheckIn,
                    CheckOut = x.CheckOut,
                    SubTotal = x.SubTotal,
                    Discount = x.Discount,
                    Total = x.Total,
                    StatusId = x.StatusId,
                    VoucherCode = x.VoucherCode,
                    CustomerId = x.CustomerId,
                    CenterId = x.CenterId,
                    Rating = x.Rating,
                    CustomerNote = x.CustomerNote,
                    StaffNote = x.StaffNote,
                    Center = x.Center
                })
                .Where(x => x.CustomerId == CustomerId);

            if (StatusId > 0 && StatusId != null)
            {
                query = query.Where(x => x.StatusId == StatusId);
            }

            return query.ToList();
        }
    }
}
