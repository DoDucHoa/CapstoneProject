using Microsoft.EntityFrameworkCore;
using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class BookingDetailRepository : Repository<BookingDetail>, IBookingDetailRepository
    {
        private readonly ApplicationDbContext _db;

        public BookingDetailRepository(ApplicationDbContext db) : base(db)
        {
            _db = db;
        }

        public IEnumerable<BookingDetail> GetBookingDetailForSearch(int Id)
        {
            IQueryable<BookingDetail> query = _dbSet;

            query = query.Where(x => x.BookingId == Id);

            return query.ToList();
        }
    }
}
