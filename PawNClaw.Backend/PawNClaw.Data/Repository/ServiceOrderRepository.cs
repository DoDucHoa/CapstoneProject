using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class ServiceOrderRepository : Repository<ServiceOrder>, IServiceOrderRepository
    {
        public ServiceOrderRepository(ApplicationDbContext db) : base(db)
        {
        }

        public void RemoveServiceOrder(int BookingId, int ServiceId)
        {
            _dbSet.Remove(_dbSet.Find(ServiceId, BookingId));
        }
    }
}
