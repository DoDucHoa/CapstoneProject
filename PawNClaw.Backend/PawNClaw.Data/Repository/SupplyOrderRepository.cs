using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class SupplyOrderRepository : Repository<SupplyOrder>, ISupplyOrderRepository
    {
        public SupplyOrderRepository(ApplicationDbContext db) : base(db)
        {
        }

        public void RemoveSupplyOrder(int BookingId, int SupplyId)
        {
            _dbSet.Remove(_dbSet.Find(SupplyId,BookingId));
        }

        public IEnumerable<SupplyOrder> GetSupplyOrdersByPetIdAndBookingId(int BookingId, int PetId)
        {
            return _dbSet.Where(x => x.BookingId == BookingId && x.PetId == PetId);
        }
    }
}
