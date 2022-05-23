using Microsoft.EntityFrameworkCore;
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

        public bool Confirm(int Id, int StatusId)
        {
            Booking query = _dbSet.FirstOrDefault(x => x.Id == Id);
            query.StatusId = StatusId;
            _dbSet.Update(query);
            return (_db.SaveChanges() >= 0);
        }

        public IEnumerable<Booking> GetBookingForStaff(BookingRequestParameter bookingRequestParameter)
        {
            IQueryable<Booking> query = _dbSet;

            if (bookingRequestParameter.Id.HasValue)
            {
                query = query.Where(x => x.Id == bookingRequestParameter.Id);
            }
            if (bookingRequestParameter.CenterId.HasValue)
            {
                query = query.Where(x => x.CenterId == bookingRequestParameter.CenterId);
            }
            if (bookingRequestParameter.CustomerId.HasValue)
            {
                query = query.Where(x => x.CustomerId == bookingRequestParameter.CustomerId);
            }
            if (bookingRequestParameter.StatusId.HasValue)
            {
                query = query.Where(x => x.StatusId == bookingRequestParameter.StatusId);
            }

            if (bookingRequestParameter.includeProperties != null)
            {
                foreach (var includeProp in bookingRequestParameter.includeProperties.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
                {
                    query = query.Include(includeProp);
                }
            }

            if (bookingRequestParameter.dir == "asc")
                query = query.OrderBy(d => d.CreateTime);
            else if (bookingRequestParameter.dir == "desc")
                query = query.OrderByDescending(d => d.CreateTime);

            return query.ToList();
        }
    }
}
