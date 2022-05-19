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
    public class CageTypeRepository : Repository<CageType>, ICageTypeRepository
    {
        public CageTypeRepository(ApplicationDbContext db) : base(db)
        {
        }

        public IEnumerable<CageType> GetAllCageWithCageType(int centerId)
        {
            IQueryable<CageType> query = _dbSet;

            query = query.Include("Cages")
                            .Include("Prices")
                            .Where(x => x.CenterId == centerId);

            return query.ToList();
        }
    }
}
