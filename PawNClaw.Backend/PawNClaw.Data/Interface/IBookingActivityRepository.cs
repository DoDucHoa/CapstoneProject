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
        public void CreateBookingAcivities(CreateBookingActivityParameter createBookingActivityParameter);
    }
}
