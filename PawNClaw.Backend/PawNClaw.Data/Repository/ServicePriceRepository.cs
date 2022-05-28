using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class ServicePriceRepository : Repository<ServicePrice>, IServicePriceRepository
    {
        public ServicePriceRepository(ApplicationDbContext db) : base(db)
        {
        }
    }
}
