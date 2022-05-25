using Microsoft.EntityFrameworkCore.Storage;
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

        private readonly ApplicationDbContext _db;

        public BookingService(IBookingRepository bookingRepository, IBookingDetailRepository bookingDetailRepository, 
            IPetBookingDetailRepository petBookingDetailRepository, IServiceOrderRepository serviceOrderRepository, 
            ISupplyOrderRepository supplyOrderRepository, ISupplyRepository supplyRepository,
            ApplicationDbContext db)
        {
            _bookingRepository = bookingRepository;
            _bookingDetailRepository = bookingDetailRepository;
            _petBookingDetailRepository = petBookingDetailRepository;
            _serviceOrderRepository = serviceOrderRepository;
            _supplyOrderRepository = supplyOrderRepository;
            _supplyRepository = supplyRepository;
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

        public PagedList<Booking> GetBookings(BookingRequestParameter bookingRequestParameter, PagingParameter paging)
        {
            var values = _bookingRepository.GetBookingForStaff(bookingRequestParameter);
            return PagedList<Booking>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        public async Task<Booking> CreateBooking(BookingCreateParameter bookingCreateParameter, 

            List<BookingDetailCreateParameter> bookingDetailCreateParameters,
            List<ServiceOrderCreateParameter> serviceOrderCreateParameters,
            List<SupplyOrderCreateParameter> supplyOrderCreateParameters)
        {

            int Id = 0;
            using (IDbContextTransaction transaction = _db.Database.BeginTransaction())
            {
                //Create Booking
                Booking bookingToDb = new Booking()
                {
                    CreateTime = bookingCreateParameter.CreateTime,
                    StartBooking = bookingCreateParameter.StartBooking,
                    EndBooking = bookingCreateParameter.EndBooking,
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
                int Line = 0;
                foreach (var bookingDetail in bookingDetailCreateParameters)
                {
                    Line++;
                    BookingDetail bookingDetailToDb = new BookingDetail()
                    {
                        BookingId = bookingToDb.Id,
                        Line = Line,
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

                    foreach (var PetId in bookingDetail.PetId)
                    {
                        PetBookingDetail petBookingDetailToDb = new PetBookingDetail()
                        {
                            BookingId = bookingDetailToDb.BookingId,
                            Line = bookingDetailToDb.Line,
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
                        ServiceOrder serviceOrderToDb = new ServiceOrder()
                        {
                            ServiceId = serviceOrder.ServiceId,
                            BookingId = bookingToDb.Id,
                            Quantity = serviceOrder.Quantity,
                            SellPrice = serviceOrder.SellPrice,
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

                transaction.Commit();
            }

            //Return Booking
            var values = _bookingRepository.GetBookingForCustomer(Id);

            return values;
}
    }
}
