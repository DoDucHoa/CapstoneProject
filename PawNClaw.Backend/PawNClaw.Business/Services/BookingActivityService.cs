using Microsoft.EntityFrameworkCore.Storage;
using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class BookingActivityService
    {
        IBookingActivityRepository _bookingActivityRepository;
        IPhotoRepository _photoRepository;

        private readonly ApplicationDbContext _db;

        public BookingActivityService(IBookingActivityRepository bookingActivityRepository, IPhotoRepository photoRepository,
            ApplicationDbContext db)
        {
            _bookingActivityRepository = bookingActivityRepository;
            _photoRepository = photoRepository;
            _db = db;
        }

        public async Task<bool> CreateBookingActivity(CreateBookingActivityControllerParameter createBookingActivityControllerParameter)
        {
            using (IDbContextTransaction transaction = _db.Database.BeginTransaction())
            {

                BookingActivity bookingActivity = new BookingActivity();
                bookingActivity.ProvideTime = createBookingActivityControllerParameter.createBookingActivityParameter.ProvideTime;
                bookingActivity.Description = createBookingActivityControllerParameter.createBookingActivityParameter.Description;
                bookingActivity.BookingId = createBookingActivityControllerParameter.createBookingActivityParameter.BookingId;
                bookingActivity.Line = createBookingActivityControllerParameter.createBookingActivityParameter.Line;
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
    }
}
