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
    public class PetBookingDetailRepository : Repository<PetBookingDetail>, IPetBookingDetailRepository
    {
        public PetBookingDetailRepository(ApplicationDbContext db) : base(db)
        {
        }

        public IEnumerable<PetBookingDetail> GetPetBookingDetailsByBookingId(int BookingId)
        {
            IQueryable<PetBookingDetail> query = _dbSet
                .Include(x => x.Pet)
                .Select(x => new PetBookingDetail
                {
                    BookingId = x.BookingId,
                    Line = x.Line,
                    Pet = x.Pet
                })
                .Where(x => x.BookingId == BookingId);

            return query.ToList();
        }
    }
}
