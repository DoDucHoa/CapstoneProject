using PawNClaw.Data.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Interface
{
    public interface ISupplyOrderRepository : IRepository<SupplyOrder>
    {
        public void RemoveSupplyOrder(int BookingId, int SupplyId);

        public IEnumerable<SupplyOrder> GetSupplyOrdersByPetIdAndBookingId(int BookingId, int PetId);
    }
}
