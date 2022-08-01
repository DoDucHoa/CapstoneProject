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
    public class BookingActivityRepository : Repository<BookingActivity>, IBookingActivityRepository
    {
        IPhotoRepository _photoRepository;
        public BookingActivityRepository(ApplicationDbContext db, IPhotoRepository photoRepository) : base(db)
        {
            _photoRepository = photoRepository;
        }

        public int CreateBookingAcivities(CreateBookingActivityParameter createBookingActivityParameter)
        {
            BookingActivity bookingActivity = new BookingActivity();
            bookingActivity.ProvideTime = createBookingActivityParameter.ProvideTime;
            bookingActivity.Description = createBookingActivityParameter.Description;
            bookingActivity.BookingId = createBookingActivityParameter.BookingId;
            bookingActivity.BookingDetailId = createBookingActivityParameter.BookingDetailId;
            bookingActivity.PetId = createBookingActivityParameter.PetId;
            bookingActivity.SupplyId = createBookingActivityParameter.SupplyId;
            bookingActivity.ServiceId = createBookingActivityParameter.ServiceId;

            _dbSet.Add(bookingActivity);

            return bookingActivity.Id;
        }

        public IEnumerable<BookingActivity> GetBookingActivitiesByBookingAndPetId(int BookingId, int BookingDetailId, int PetId)
        {
            return _dbSet.Where(x => (x.BookingId == BookingId && x.BookingDetailId == BookingDetailId) || (x.BookingId == BookingId && x.PetId == PetId));
        }

        public BookingActivity GetBookingActivityWithPhoto(int id)
        {
            var activity = _dbSet.FirstOrDefault(x => x.Id == id);
            activity.Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(id, PhotoTypesConst.BookingActivity);
            return activity;
        }
    }
}
