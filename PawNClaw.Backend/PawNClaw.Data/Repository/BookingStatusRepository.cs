using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class BookingStatusRepository : Repository<BookingStatus>, IBookingStatusRepository
    {
        public BookingStatusRepository(ApplicationDbContext db) : base(db)
        {
        }
    }
}
