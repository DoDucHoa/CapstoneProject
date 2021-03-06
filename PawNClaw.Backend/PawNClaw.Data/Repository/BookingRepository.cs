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

namespace PawNClaw.Data.Repository
{
    public class BookingRepository : Repository<Booking>, IBookingRepository
    {
        private readonly ApplicationDbContext _db;

        PhotoRepository _photoRepository;

        ISupplyOrderRepository _supplyOrderRepository;
        IServiceOrderRepository _serviceOrderRepository;
        IBookingActivityRepository _bookingActivityRepository;

        public BookingRepository(ApplicationDbContext db, PhotoRepository photoRepository, 
            ISupplyOrderRepository supplyOrderRepository, IServiceOrderRepository serviceOrderRepository,
            IBookingActivityRepository bookingActivityRepository) : base(db)
        {
            _db = db;
            _photoRepository = photoRepository;
            _supplyOrderRepository = supplyOrderRepository;
            _serviceOrderRepository = serviceOrderRepository;
            _bookingActivityRepository = bookingActivityRepository;
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
            if (bookingRequestParameter.StartBooking.HasValue && bookingRequestParameter.EndBooking.HasValue)
            {
                query = query.Where(x =>
                            ((DateTime.Compare((DateTime)bookingRequestParameter.StartBooking, (DateTime)x.StartBooking) <= 0
                            && DateTime.Compare((DateTime)bookingRequestParameter.EndBooking, (DateTime)x.EndBooking) >= 0)
                            ||
                            (DateTime.Compare((DateTime)bookingRequestParameter.StartBooking, (DateTime)x.StartBooking) >= 0
                            && DateTime.Compare((DateTime)bookingRequestParameter.StartBooking, (DateTime)x.EndBooking) < 0)
                            ||
                            (DateTime.Compare((DateTime)bookingRequestParameter.EndBooking, (DateTime)x.StartBooking) > 0
                            && DateTime.Compare((DateTime)bookingRequestParameter.EndBooking, (DateTime)x.EndBooking) <= 0)));
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
                        Id = bookingdetail.Id,
                        BookingId = bookingdetail.BookingId,
                        Price = bookingdetail.Price,
                        CageCode = bookingdetail.CageCode,
                        CenterId = bookingdetail.CenterId,
                        Duration = bookingdetail.Duration,
                        Note = bookingdetail.Note,
                        C = new Cage
                        {
                            Name = bookingdetail.C.Name,
                            CageType = new CageType
                            {
                                TypeName = bookingdetail.C.CageType.TypeName,
                                Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(bookingdetail.C.CageType.Id, PhotoTypesConst.CageType)
                            }
                        },
                        PetBookingDetails = (ICollection<PetBookingDetail>)bookingdetail.PetBookingDetails
                        .Select(pet => new PetBookingDetail
                        {
                            BookingDetailId = pet.BookingDetailId,
                            Pet = new Pet
                            {
                                Id = pet.Pet.Id,
                                Name = pet.Pet.Name,
                                Height = pet.Pet.Height,
                                Length = pet.Pet.Length,
                                Weight = pet.Pet.Weight,
                                Birth = pet.Pet.Birth,
                                BreedName = pet.Pet.BreedName,
                                PetHealthHistories = (ICollection<PetHealthHistory>)pet.Pet.PetHealthHistories.Where(pethealth => pethealth.BookingId == BookingId),
                                Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(pet.Pet.Id, PhotoTypesConst.PetProfile)
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
                        Name = x.Customer.Name,
                        IdNavigation = new Account
                        {
                            Phone = x.Customer.IdNavigation.Phone
                        }
                    },
                    Status = new BookingStatus
                    {
                        Id = x.Status.Id,
                        Name = x.Status.Name
                    },
                    BookingActivities = (ICollection<BookingActivity>)x.BookingActivities
                    .Select(bookingact => new BookingActivity
                    {
                        Id = bookingact.Id,
                        ProvideTime = bookingact.ProvideTime,
                        Description = bookingact.Description,
                        BookingId = bookingact.BookingId,
                        PetId = bookingact.PetId,
                        SupplyId = bookingact.SupplyId,
                        ServiceId = bookingact.ServiceId,
                        ActivityTimeFrom = bookingact.ActivityTimeFrom,
                        ActivityTimeTo = bookingact.ActivityTimeTo,
                        BookingDetailId = bookingact.BookingDetailId,
                        IsOnTime = bookingact.IsOnTime,
                        Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(bookingact.Id, PhotoTypesConst.BookingActivity)
                    }),
                    TotalSupply = x.SupplyOrders.Sum(supply => supply.TotalPrice),
                    TotalService = x.ServiceOrders.Sum(service => service.TotalPrice)
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
                        Id = bookingdetail.Id,
                        BookingId = bookingdetail.BookingId,
                        Price = bookingdetail.Price,
                        CageCode = bookingdetail.CageCode,
                        CenterId = bookingdetail.CenterId,
                        Duration = bookingdetail.Duration,
                        Note = bookingdetail.Note,
                        C = new Cage
                        {
                            Name = bookingdetail.C.Name,
                            CageType = new CageType
                            {
                                TypeName = bookingdetail.C.CageType.TypeName
                            }
                        },
                        PetBookingDetails = (ICollection<PetBookingDetail>)bookingdetail.PetBookingDetails
                        .Select(pet => new PetBookingDetail
                        {
                            BookingDetailId = pet.BookingDetailId,
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
                        Name = x.Customer.Name,
                        IdNavigation = new Account
                        {
                            Phone = x.Customer.IdNavigation.Phone
                        }
                    },
                    Status = new BookingStatus
                    {
                        Id = x.Status.Id,
                        Name = x.Status.Name
                    },
                    BookingActivities = (ICollection<BookingActivity>)x.BookingActivities
                    .Select(bookingact => new BookingActivity
                    {
                        Id = bookingact.Id,
                        ProvideTime = bookingact.ProvideTime,
                        Description = bookingact.Description,
                        BookingId = bookingact.BookingId,
                        PetId = bookingact.PetId,
                        SupplyId = bookingact.SupplyId,
                        ServiceId = bookingact.ServiceId,
                        ActivityTimeFrom = bookingact.ActivityTimeFrom,
                        ActivityTimeTo = bookingact.ActivityTimeTo,
                        BookingDetailId = bookingact.BookingDetailId,
                        IsOnTime = bookingact.IsOnTime,
                        Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(bookingact.Id, PhotoTypesConst.BookingActivity)
                    }),
                    TotalSupply = x.SupplyOrders.Sum(supply => supply.TotalPrice),
                    TotalService = x.ServiceOrders.Sum(service => service.TotalPrice)
                })
                .SingleOrDefault(x => x.Id == BookingId);

            return query;
        }

        public IEnumerable<Booking> GetBookingByCenterIdForStaff(int CenterId, int? StatusId)
        {
            DateTime now = DateTime.Today;

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
                    Customer = new Customer
                    {
                        Name = x.Customer.Name,
                        IdNavigation = new Account
                        {
                            Phone = x.Customer.IdNavigation.Phone
                        }
                    },
                    BookingDetails = (ICollection<BookingDetail>)x.BookingDetails
                    .Select(bookingdetail => new BookingDetail
                    {
                        Id = bookingdetail.Id,
                        BookingId = bookingdetail.BookingId,
                        Price = bookingdetail.Price,
                        CageCode = bookingdetail.CageCode,
                        CageType = bookingdetail.C.CageType.TypeName,
                        CenterId = bookingdetail.CenterId,
                        Duration = bookingdetail.Duration,
                        Note = bookingdetail.Note,
                        PetBookingDetails = (ICollection<PetBookingDetail>)bookingdetail.PetBookingDetails
                        .Select(pet => new PetBookingDetail
                        {
                            BookingDetailId = pet.BookingDetailId,
                            Pet = new Pet
                            {
                                Id = pet.Pet.Id,
                                Name = pet.Pet.Name,
                                Height = pet.Pet.Height,
                                Length = pet.Pet.Length,
                                Weight = pet.Pet.Weight,
                                Birth = pet.Pet.Birth,
                                BreedName = pet.Pet.BreedName,
                                PetHealthHistories = (ICollection<PetHealthHistory>)pet.Pet.PetHealthHistories.Where(pethealth => pethealth.BookingId == bookingdetail.BookingId)
                            }
                        }),
                        BookingActivities = bookingdetail.BookingActivities,
                        FoodSchedules = bookingdetail.C.CageType.FoodSchedules
                    }),
                    TotalSupply = x.SupplyOrders.Sum(supply => supply.TotalPrice),
                    TotalService = x.ServiceOrders.Sum(service => service.TotalPrice),
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
                            BreedName = supplyorder.Pet.BreedName,
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
                            BreedName = serviceorder.Pet.BreedName,
                            Name = serviceorder.Pet.Name,
                        }
                    }),
                    BookingActivities = (ICollection<BookingActivity>)x.BookingActivities
                    .Where(x => now.Date >= ((DateTime)x.ActivityTimeFrom).Date && now <= ((DateTime)x.ActivityTimeTo).Date)
                    .Select(bookingact => new BookingActivity
                    {
                        Id = bookingact.Id,
                        ProvideTime = bookingact.ProvideTime,
                        Description = bookingact.Description,
                        BookingId = bookingact.BookingId,
                        PetId = bookingact.PetId,
                        SupplyId = bookingact.SupplyId,
                        ServiceId = bookingact.ServiceId,
                        ActivityTimeFrom = bookingact.ActivityTimeFrom,
                        ActivityTimeTo = bookingact.ActivityTimeTo,
                        BookingDetailId = bookingact.BookingDetailId,
                        IsOnTime = bookingact.IsOnTime,
                        BookingDetail = bookingact.BookingDetail,
                        Service = bookingact.Service,
                        Supply = bookingact.Supply,
                        Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(bookingact.Id, PhotoTypesConst.BookingActivity)
                    })
                })
                .Where(x => x.CenterId == CenterId && x.StatusId == StatusId);

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
                    Center = x.Center,
                    Status = new BookingStatus
                    {
                        Id = x.Status.Id,
                        Name = x.Status.Name
                    },
                    TotalSupply = x.SupplyOrders.Sum(supply => supply.TotalPrice),
                    TotalService = x.ServiceOrders.Sum(service => service.TotalPrice)
                })
                .Where(x => x.CustomerId == CustomerId);

            if (StatusId > 0 && StatusId != null)
            {
                query = query.Where(x => x.StatusId == StatusId);
            }

            return query.ToList();
        }

        public Booking GetBookingForCreateActivity(int BookingId)
        {
            Booking query = _dbSet
                .Select(x => new Booking
                {
                    Id = x.Id,
                    StartBooking = x.StartBooking,
                    EndBooking = x.EndBooking,
                    BookingDetails = (ICollection<BookingDetail>)x.BookingDetails
                    .Select(bookingdetail => new BookingDetail
                    {
                        Id = bookingdetail.Id,
                        BookingId = bookingdetail.BookingId,
                        CageCode = bookingdetail.CageCode,
                        CenterId = bookingdetail.CenterId,
                        Duration = bookingdetail.Duration,
                        Note = bookingdetail.Note,
                        C = new Cage
                        {
                            Name = bookingdetail.C.Name,
                            CageType = new CageType
                            {
                                TypeName = bookingdetail.C.CageType.TypeName,
                                FoodSchedules = bookingdetail.C.CageType.FoodSchedules
                            }
                        }
                    }),
                    SupplyOrders = (ICollection<SupplyOrder>)x.SupplyOrders
                    .Select(supplyorder => new SupplyOrder
                    {
                        SupplyId = supplyorder.SupplyId,
                        BookingId = supplyorder.BookingId,
                        PetId = supplyorder.PetId,
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
                        PetId = serviceorder.PetId,
                        Pet = new Pet
                        {
                            Name = serviceorder.Pet.Name,
                        }
                    })
                })
                .SingleOrDefault(x => x.Id == BookingId);

            return query;
        }

        public Booking GetBookingByCageCodeForStaff(int CenterId, int? StatusId, string CageCode)
        {
            Booking query = _dbSet
                .Where(x => x.CenterId == CenterId && x.StatusId == StatusId).Where(x => x.BookingDetails.Any(bookingdetail => bookingdetail.CageCode.Equals(CageCode)))
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
                        Id = bookingdetail.Id,
                        BookingId = bookingdetail.BookingId,
                        Price = bookingdetail.Price,
                        CageCode = bookingdetail.CageCode,
                        CageType = bookingdetail.C.CageType.TypeName,
                        CenterId = bookingdetail.CenterId,
                        Duration = bookingdetail.Duration,
                        Note = bookingdetail.Note,
                        PetBookingDetails = (ICollection<PetBookingDetail>)bookingdetail.PetBookingDetails
                        .Select(pet => new PetBookingDetail
                        {
                            BookingDetailId = pet.BookingDetailId,
                            PetId = pet.PetId,
                            Pet = pet.Pet
                        })
                    })
                    .Where(bookingdetail => bookingdetail.CageCode.Equals(CageCode))
                }).FirstOrDefault();


            foreach (var bookingDetail in query.BookingDetails)
            {
                foreach (var petBooking in bookingDetail.PetBookingDetails)
                {
                    var supplyOrders = _supplyOrderRepository.GetSupplyOrdersByPetIdAndBookingId(query.Id, petBooking.PetId).ToList();

                    supplyOrders.ForEach(o => query.SupplyOrders.Add(o));
                    var serviceOrder = _serviceOrderRepository.GetServiceOrdersByPetIdAndBookingId(query.Id, petBooking.PetId).ToList();
                    serviceOrder.ForEach(o => query.ServiceOrders.Add(o));
                    var bookingActivity = _bookingActivityRepository.GetBookingActivitiesByBookingAndPetId(query.Id, bookingDetail.Id, petBooking.PetId).ToList();
                    bookingActivity.ForEach(o => query.BookingActivities.Add(o));
                }
            }


            return query;
        }
    }
}
