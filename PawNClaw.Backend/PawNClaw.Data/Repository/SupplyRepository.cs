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
    public class SupplyRepository : Repository<Supply>, ISupplyRepository
    {
        private ApplicationDbContext _db;


        public SupplyRepository(ApplicationDbContext db) : base(db)
        {
            _db = db;
        }

        public IEnumerable<Supply> GetSuppliesWithType(int centerId)
        {
            IQueryable<Supply> query = _dbSet;

            var values = query.Include(x => x.SupplyTypeCodeNavigation).Where(x => x.CenterId == centerId);

            return values;
        }
    }
}
