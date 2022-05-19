using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class ServiceRepository : Repository<Service>, IServiceRepository
    {
        public ServiceRepository(ApplicationDbContext db) : base(db)
        {
        }

        public IEnumerable<Service> GetServicesOfCenter(int centerId)
        {
            IQueryable<Service> query = _dbSet;

            query = query.Where(x => x.CenterId == centerId);

            return query.ToList();
        }
    }
}
