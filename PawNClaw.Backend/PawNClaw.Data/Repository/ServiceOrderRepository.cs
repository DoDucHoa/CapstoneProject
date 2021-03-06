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

        public IEnumerable<ServiceOrder> GetServiceOrdersByPetIdAndBookingId(int BookingId, int PetId)
        {
            return _dbSet.Where(x => x.BookingId == BookingId && x.PetId == PetId).Select(x => new ServiceOrder { 
                BookingId = x.BookingId,
                Note = x.Note,
                PetId = x.PetId,
                ServiceId = x.ServiceId,
                Service = x.Service,
                Quantity = x.Quantity
            });
        }
    }
}
