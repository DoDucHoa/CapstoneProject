using Microsoft.EntityFrameworkCore.Storage;
using PawNClaw.Data.Const;
using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;

namespace PawNClaw.Business.Services
{
    public class BookingService
    {
        IBookingRepository _bookingRepository;
        IBookingDetailRepository _bookingDetailRepository;
        IPetBookingDetailRepository _petBookingDetailRepository;
        IServiceOrderRepository _serviceOrderRepository;
        ISupplyOrderRepository _supplyOrderRepository;
        ISupplyRepository _supplyRepository;
        IServicePriceRepository _servicePriceRepository;
        IPetRepository _petRepository;
        ICageRepository _cageRepository;
        IStaffRepository _staffRepository;

        private readonly ApplicationDbContext _db;

        public BookingService(IBookingRepository bookingRepository, IBookingDetailRepository bookingDetailRepository,
            IPetBookingDetailRepository petBookingDetailRepository, IServiceOrderRepository serviceOrderRepository,
            ISupplyOrderRepository supplyOrderRepository, ISupplyRepository supplyRepository,
            IServicePriceRepository servicePriceRepository, IPetRepository petRepository,
            ICageRepository cageRepository, IStaffRepository staffRepository,
            ApplicationDbContext db)
        {
            _bookingRepository = bookingRepository;
            _bookingDetailRepository = bookingDetailRepository;
            _petBookingDetailRepository = petBookingDetailRepository;
            _serviceOrderRepository = serviceOrderRepository;
            _supplyOrderRepository = supplyOrderRepository;
            _supplyRepository = supplyRepository;
            _servicePriceRepository = servicePriceRepository;
            _petRepository = petRepository;
            _cageRepository = cageRepository;
            _staffRepository = staffRepository;
            _db = db;
        }

        public bool Confirm(int Id, int StatusId)
        {
            if (_bookingRepository.Confirm(Id, StatusId))
            {
                return true;
            }
            else return false;
        }

        public bool ConfirmBooking(int Id, int StatusId, string StaffNote)
        {
            if (StatusId == 4 && StaffNote == null)
            {
                return false;
            }

            var booking = _bookingRepository.Get(Id);

            booking.StaffNote = StaffNote;

            try
            {
                _bookingRepository.Update(booking);
                _bookingRepository.SaveDbChange();
                if (!Confirm(Id, StatusId))
                {
                    return false;
                }
            }
            catch
            {
                return false;
            }

            return true;
        }

        public IEnumerable<Booking> GetBookings(BookingRequestParameter bookingRequestParameter)
        {
            var values = _bookingRepository.GetBookingForStaff(bookingRequestParameter);
            return values;
        }

        //Create Booking
        public async Task<Booking> CreateBooking(BookingCreateParameter bookingCreateParameter,
            List<BookingDetailCreateParameter> bookingDetailCreateParameters,
            List<ServiceOrderCreateParameter> serviceOrderCreateParameters,
            List<SupplyOrderCreateParameter> supplyOrderCreateParameters)
        {

            int Id = 0;

            //Check cage is booking and pet is booking in time
            foreach (var bookingDetailCreateParameter in bookingDetailCreateParameters)
            {
                if (_cageRepository.GetAll(cage => cage.Code.Trim().Equals(bookingDetailCreateParameter.CageCode) && cage.BookingDetails.Any(bookingdetail =>
                                ((DateTime.Compare((DateTime)bookingCreateParameter.StartBooking, (DateTime)bookingdetail.Booking.StartBooking) <= 0
                                && DateTime.Compare((DateTime)bookingCreateParameter.EndBooking, (DateTime)bookingdetail.Booking.EndBooking) >= 0)
                                ||
                                (DateTime.Compare((DateTime)bookingCreateParameter.StartBooking, (DateTime)bookingdetail.Booking.StartBooking) >= 0
                                && DateTime.Compare((DateTime)bookingCreateParameter.StartBooking, (DateTime)bookingdetail.Booking.EndBooking) < 0)
                                ||
                                (DateTime.Compare((DateTime)bookingCreateParameter.EndBooking, (DateTime)bookingdetail.Booking.StartBooking) > 0
                                && DateTime.Compare((DateTime)bookingCreateParameter.EndBooking, (DateTime)bookingdetail.Booking.EndBooking) <= 0)))).Count() != 0)
                {
                    throw new Exception("This Cage Has Been Used With Booking Time");
                }
            }


            using (IDbContextTransaction transaction = _db.Database.BeginTransaction())
            {
                //Create Booking
                Booking bookingToDb = new Booking()
                {
                    CreateTime = bookingCreateParameter.CreateTime,
                    StartBooking = bookingCreateParameter.StartBooking,
                    EndBooking = bookingCreateParameter.EndBooking,
                    Total = bookingCreateParameter.Total,
                    StatusId = bookingCreateParameter.StatusId,
                    VoucherCode = bookingCreateParameter.VoucherCode,
                    CustomerId = bookingCreateParameter.CustomerId,
                    CenterId = bookingCreateParameter.CenterId,
                    CustomerNote = bookingCreateParameter.CustomerNote
                };

                try
                {
                    _bookingRepository.Add(bookingToDb);
                    await _bookingRepository.SaveDbChangeAsync();
                    Id = bookingToDb.Id;
                }
                catch
                {
                    transaction.Rollback();
                    throw new Exception();
                }



                //Create Booking Detail
                foreach (var bookingDetail in bookingDetailCreateParameters)
                {
                    BookingDetail bookingDetailToDb = new BookingDetail()
                    {
                        BookingId = bookingToDb.Id,
                        Price = bookingDetail.Price,
                        CageCode = bookingDetail.CageCode,
                        CenterId = bookingToDb.CenterId,
                        Duration = bookingDetail.Duration,
                        Note = bookingDetail.Note
                    };

                    try
                    {
                        _bookingDetailRepository.Add(bookingDetailToDb);
                        await _bookingRepository.SaveDbChangeAsync();
                    }
                    catch
                    {
                        transaction.Rollback();
                        throw new Exception();
                    }

                    decimal PetHeight = 0;
                    decimal PetWidth = 0;
                    int checkSingle = 0;
                    foreach (var PetId in bookingDetail.PetId)
                    {


                        //Get Size Pet With Cage
                        var pet = _petRepository.Get(PetId);

                        if (PetHeight < (decimal)(pet.Height + SearchConst.HeightAdd))
                        {
                            PetHeight = (decimal)(pet.Height + SearchConst.HeightAdd);
                        }

                        PetWidth += (decimal)Math.Round((((double)pet.Length) + ((double)pet.Height)) / SearchConst.WidthRatio, 0);
                        //End Get Size

                        //Check Size Is Avaliable
                        var cage = _cageRepository.GetCageWithCageType(bookingDetail.CageCode, bookingToDb.CenterId);

                        checkSingle++;

                        if (checkSingle > 1 && cage.CageType.IsSingle)
                        {
                            transaction.Rollback();
                            throw new Exception("This Cage For Single Pet");
                        }

                        decimal CageHeight = cage.CageType.Height;
                        decimal CageWidth = cage.CageType.Width;

                        if (PetHeight > CageHeight || PetWidth > CageWidth)
                        {
                            transaction.Rollback();
                            throw new Exception("Pet Not Fit With Cage Size");
                        }
                        //End Check Size Is Avaliable

                        PetBookingDetail petBookingDetailToDb = new PetBookingDetail()
                        {
                            BookingDetailId = bookingDetailToDb.Id,
                            PetId = PetId
                        };

                        try
                        {
                            _petBookingDetailRepository.Add(petBookingDetailToDb);
                            await _bookingRepository.SaveDbChangeAsync();
                        }
                        catch
                        {
                            transaction.Rollback();
                            throw new Exception();
                        }
                    }
                }

                //Create Service Order
                if (serviceOrderCreateParameters != null)
                {
                    foreach (var serviceOrder in serviceOrderCreateParameters)
                    {

                        var pet = _petRepository.Get(serviceOrder.PetId);

                        decimal servicePrice = _servicePriceRepository.GetFirstOrDefault(x => x.ServiceId == serviceOrder.ServiceId
                                                                        && x.MinWeight <= pet.Weight
                                                                        && x.MaxWeight >= pet.Weight).Price;

                        ServiceOrder serviceOrderToDb = new ServiceOrder()
                        {
                            ServiceId = serviceOrder.ServiceId,
                            BookingId = bookingToDb.Id,
                            Quantity = serviceOrder.Quantity,
                            SellPrice = servicePrice,
                            TotalPrice = serviceOrder.Quantity * serviceOrder.SellPrice,
                            Note = serviceOrder.Note,
                            PetId = serviceOrder.PetId
                        };

                        try
                        {
                            _serviceOrderRepository.Add(serviceOrderToDb);
                            await _bookingRepository.SaveDbChangeAsync();
                        }
                        catch
                        {
                            transaction.Rollback();
                            throw new Exception();
                        }
                    }
                }

                //Create Supply Order
                if (supplyOrderCreateParameters != null)
                {
                    foreach (var supplyOrder in supplyOrderCreateParameters)
                    {

                        SupplyOrder supplyOrderToDb = new SupplyOrder()
                        {
                            SupplyId = supplyOrder.SupplyId,
                            BookingId = bookingToDb.Id,
                            Quantity = supplyOrder.Quantity,
                            SellPrice = supplyOrder.SellPrice,
                            TotalPrice = supplyOrder.Quantity * supplyOrder.SellPrice,
                            Note = supplyOrder.Note,
                            PetId = supplyOrder.PetId
                        };

                        try
                        {
                            _supplyOrderRepository.Add(supplyOrderToDb);
                            await _bookingRepository.SaveDbChangeAsync();

                            var supply = _supplyRepository.Get(supplyOrder.SupplyId);

                            supply.Quantity = (int)(supply.Quantity - supplyOrder.Quantity);

                            if (supply.Quantity < 0)
                            {
                                transaction.Rollback();
                                throw new Exception("Quantity is INVALID");
                            }

                            _supplyRepository.Update(supply);
                            await _supplyRepository.SaveDbChangeAsync();
                        }
                        catch
                        {
                            transaction.Rollback();
                            throw new Exception();
                        }
                    }
                }

                try
                {

                    var serviceOrders = bookingToDb.ServiceOrders;

                    var supplyOrders = bookingToDb.SupplyOrders;

                    var bookingDetails = bookingToDb.BookingDetails;

                    decimal Price = 0;

                    foreach (var serviceOrder in serviceOrders)
                    {
                        Price = (decimal)(Price + serviceOrder.TotalPrice);
                    }

                    foreach (var supplyOrder in supplyOrders)
                    {
                        Price = (decimal)(Price + supplyOrder.TotalPrice);
                    }

                    foreach (var bookingDetail in bookingDetails)
                    {
                        Price = (decimal)(Price + bookingDetail.Price);
                    }

                    bookingToDb.SubTotal = Price;
                    bookingToDb.Total = Price;

                    _bookingRepository.Update(bookingToDb);
                    await _bookingRepository.SaveDbChangeAsync();
                }
                catch
                {
                    transaction.Rollback();
                    throw new Exception();
                }

                transaction.Commit();
            }

            //Return Booking

            var values = _bookingRepository.GetBookingForCustomer(Id);

            return values;
        }

        //Get List Booking By Cus ID
        public IEnumerable<Booking> GetBookingsByCustomerId(int id, int? StatusId)
        {
            var values = _bookingRepository.GetBookingByCustomerId(id, StatusId);

            return values;
        }


        //Get List Booking By ID
        public Booking GetBookingById(int id)
        {
            var values = _bookingRepository.GetBookingForCustomer(id);

            return values;
        }

        //Get Booking By ID for Staff
        public Booking GetBookingByIdForStaff(int id)
        {
            var values = _bookingRepository.GetBookingForStaff(id);

            return values;
        }

        //Get List Booking for Staff Mobile
        public IEnumerable<Booking> GetBookingsForStaffMobile(int staffId, int? statusId)
        {

            var staff = _staffRepository.Get(staffId);
            var values = _bookingRepository.GetBookingByCenterIdForStaff(staff.CenterId, statusId);

            return values;
        }

    }
}
