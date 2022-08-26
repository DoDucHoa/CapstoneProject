using Microsoft.EntityFrameworkCore.Storage;
using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class BookingActivityService
    {
        private readonly IBookingActivityRepository _bookingActivityRepository;
        private readonly IPhotoRepository _photoRepository;
        private readonly IBookingRepository _bookingRepository;
        private readonly IAccountRepository _accountRepository;

        private readonly ApplicationDbContext _db;

        public BookingActivityService(IBookingActivityRepository bookingActivityRepository, IPhotoRepository photoRepository,
            IBookingRepository bookingRepository, IAccountRepository accountRepository,
            ApplicationDbContext db)
        {
            _bookingActivityRepository = bookingActivityRepository;
            _photoRepository = photoRepository;
            _bookingRepository = bookingRepository;
            _accountRepository = accountRepository;
            _db = db;
        }

        public Account GetCustomerByActivityId(int id)
        {
            var activity = _bookingActivityRepository.GetFirstOrDefault(x => x.Id == id);
            var customer = _bookingRepository.GetFirstOrDefault(x => x.Id == activity.BookingId, includeProperties: "Customer,Customer.IdNavigation").Customer.IdNavigation;
            return customer;
        }

        public BookingActivity GetById(int id)
        {
            return _bookingActivityRepository.GetBookingActivityWithPhoto(id);
        }

        public async Task<bool> CreateBookingActivity(CreateBookingActivityControllerParameter createBookingActivityControllerParameter)
        {
            using (IDbContextTransaction transaction = _db.Database.BeginTransaction())
            {

                BookingActivity bookingActivity = new BookingActivity();
                bookingActivity.ProvideTime = createBookingActivityControllerParameter.createBookingActivityParameter.ProvideTime;
                bookingActivity.Description = createBookingActivityControllerParameter.createBookingActivityParameter.Description;
                bookingActivity.BookingId = createBookingActivityControllerParameter.createBookingActivityParameter.BookingId;
                bookingActivity.BookingDetailId = createBookingActivityControllerParameter.createBookingActivityParameter.BookingDetailId;
                bookingActivity.PetId = createBookingActivityControllerParameter.createBookingActivityParameter.PetId;
                bookingActivity.SupplyId = createBookingActivityControllerParameter.createBookingActivityParameter.SupplyId;
                bookingActivity.ServiceId = createBookingActivityControllerParameter.createBookingActivityParameter.ServiceId;

                try
                {
                    _bookingActivityRepository.Add(bookingActivity);
                    await _bookingActivityRepository.SaveDbChangeAsync();

                    createBookingActivityControllerParameter.createPhotoParameter.IdActor = bookingActivity.Id;

                    _photoRepository.CreatePhotos(createBookingActivityControllerParameter.createPhotoParameter);

                    await _photoRepository.SaveDbChangeAsync();

                    transaction.Commit();
                    return true;
                }
                catch
                {
                    transaction.Rollback();
                    throw new Exception();
                }
            }
        }

        public async Task<bool> CreateBookingActivityAfterConfirm(int bookingId)
        {
            using (IDbContextTransaction transaction = _db.Database.BeginTransaction())
            {

                var booking = _bookingRepository.GetBookingForCreateActivity(bookingId);

                BookingActivity bookingActivity;

                foreach (var bookingDetail in booking.BookingDetails)
                {
                    for (int i = 0; i < bookingDetail.Duration; i++)
                    {
                        DateTime startBooking = (DateTime)booking.StartBooking;

                        startBooking = startBooking.AddDays(i);

                        foreach (var foodSchedule in bookingDetail.C.CageType.FoodSchedules)
                        {
                            bookingActivity = new BookingActivity();
                            bookingActivity.BookingId = booking.Id;
                            bookingActivity.BookingDetailId = bookingDetail.Id;
                            bookingActivity.ActivityTimeFrom = TimeHelper.SetTime(startBooking, foodSchedule.FromTime.Hours, foodSchedule.FromTime.Minutes);
                            bookingActivity.ActivityTimeTo = TimeHelper.SetTime(startBooking, foodSchedule.ToTime.Hours, foodSchedule.ToTime.Minutes);

                            try
                            {
                                _bookingActivityRepository.Add(bookingActivity);
                                await _bookingActivityRepository.SaveDbChangeAsync();
                            }
                            catch
                            {
                                transaction.Rollback();
                                throw new Exception();
                            }
                        }
                    }
                }

                foreach (var supplyOrder in booking.SupplyOrders)
                {
                    for (int i = 0; i < supplyOrder.Quantity; i++)
                    {
                        bookingActivity = new BookingActivity();
                        bookingActivity.BookingId = booking.Id;
                        bookingActivity.PetId = supplyOrder.PetId;
                        bookingActivity.SupplyId = supplyOrder.SupplyId;
                        bookingActivity.ActivityTimeFrom = booking.StartBooking;
                        bookingActivity.ActivityTimeTo = booking.EndBooking;

                        try
                        {
                            _bookingActivityRepository.Add(bookingActivity);
                            await _bookingActivityRepository.SaveDbChangeAsync();
                        }
                        catch
                        {
                            transaction.Rollback();
                            throw new Exception();
                        }
                    }
                }

                foreach (var serviceOrder in booking.ServiceOrders)
                {
                    for (int i = 0; i < serviceOrder.Quantity; i++)
                    {
                        bookingActivity = new BookingActivity();
                        bookingActivity.BookingId = booking.Id;
                        bookingActivity.PetId = serviceOrder.PetId;
                        bookingActivity.ServiceId = serviceOrder.ServiceId;
                        bookingActivity.ActivityTimeFrom = booking.StartBooking;
                        bookingActivity.ActivityTimeTo = booking.EndBooking;

                        try
                        {
                            _bookingActivityRepository.Add(bookingActivity);
                            await _bookingActivityRepository.SaveDbChangeAsync();
                        }
                        catch
                        {
                            transaction.Rollback();
                            throw new Exception();
                        }
                    }
                }

                transaction.Commit();
                return true;
            }
        }

        public async Task<bool> UpdateActivity(UpdateBookingActivityParameter updateBookingActivityParameter)
        {
            using (IDbContextTransaction transaction = _db.Database.BeginTransaction())
            {

                var bookingActivity = _bookingActivityRepository.Get(updateBookingActivityParameter.Id);
                bookingActivity.ProvideTime = updateBookingActivityParameter.ProvideTime;
                bookingActivity.Description = updateBookingActivityParameter.Description;

                if (updateBookingActivityParameter.ProvideTime >= bookingActivity.ActivityTimeFrom
                    && updateBookingActivityParameter.ProvideTime <= bookingActivity.ActivityTimeTo)
                {
                    bookingActivity.IsOnTime = true;
                }

                try
                {
                    _bookingActivityRepository.Update(bookingActivity);
                    await _bookingActivityRepository.SaveDbChangeAsync();

                    updateBookingActivityParameter.createPhotoParameter.IdActor = bookingActivity.Id;

                    _photoRepository.CreatePhotos(updateBookingActivityParameter.createPhotoParameter);

                    await _photoRepository.SaveDbChangeAsync();

                    transaction.Commit();
                    return true;
                }
                catch
                {
                    transaction.Rollback();
                    throw new Exception();
                }
            }
        }
    }
}
