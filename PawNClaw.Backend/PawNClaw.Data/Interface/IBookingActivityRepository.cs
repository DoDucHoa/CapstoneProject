using PawNClaw.Data.Database;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Interface
{
    public interface IBookingActivityRepository : IRepository<BookingActivity>
    {
        public int CreateBookingAcivities(CreateBookingActivityParameter createBookingActivityParameter);

        public IEnumerable<BookingActivity> GetBookingActivitiesByBookingAndPetId(int BookingId, int BookingDetailId, int PetId);
    }
}
