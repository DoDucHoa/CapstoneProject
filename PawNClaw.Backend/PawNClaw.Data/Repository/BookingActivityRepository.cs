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
        public BookingActivityRepository(ApplicationDbContext db) : base(db)
        {
        }

        public void CreateBookingAcivities(CreateBookingActivityParameter createBookingActivityParameter)
        {
            BookingActivity bookingActivity = new BookingActivity();
            bookingActivity.ProvideTime = createBookingActivityParameter.ProvideTime;
            bookingActivity.Description = createBookingActivityParameter.Description;
            bookingActivity.BookingId = createBookingActivityParameter.BookingId;
            bookingActivity.Line = createBookingActivityParameter.Line;
            bookingActivity.PetId = createBookingActivityParameter.PetId;
            bookingActivity.SupplyId = createBookingActivityParameter.SupplyId;
            bookingActivity.ServiceId = createBookingActivityParameter.ServiceId;

            _dbSet.Add(bookingActivity);
            
        }
    }
}
