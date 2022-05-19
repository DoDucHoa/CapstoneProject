using Microsoft.EntityFrameworkCore;
using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class SupplyTypeRepository : Repository<SupplyType>, ISupplyTypeRepository
    {
        public SupplyTypeRepository(ApplicationDbContext db) : base(db)
        {
        }

        public IEnumerable<SupplyType> GetSupplyTypes(int centerId)
        {
            IQueryable<SupplyType> query = _dbSet;

            query = query.Include("Supplies").Where(x => x.Supplies.Any());

            return query.ToList();
        }
    }
}
