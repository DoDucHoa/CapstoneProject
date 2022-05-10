using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
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

        public BookingRepository(ApplicationDbContext db) : base(db)
        {
            _db = db;
        }

        public IEnumerable<Booking> GetBookingValidSearch(int Id, DateTime _startBooking, DateTime _endBooking)
        {
            IQueryable<Booking> query = _dbSet;

            query = query.Where(x => x.CenterId == Id && (x.StatusId == 1 || x.StatusId == 2 || x.StatusId == 3)
            && DateTime.Compare(_startBooking, (DateTime)x.StartBooking) <= 0 
            && DateTime.Compare(_endBooking, (DateTime)x.EndBooking) >= 0);
            
            return query.ToList();
        }
    }
}
