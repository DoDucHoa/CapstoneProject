using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    class UpdateBookingParameter
    {
    }

    public class UpdateServiceOrderParameter
    {
        public int BookingId { get; set; }
        
        public List<ListUpdateServiceOrderParameter> listUpdateServiceOrderParameters { get; set; }
    }

    public class ListUpdateServiceOrderParameter
    {
        public int ServiceId { get; set; }
        public int Quantity { get; set; }
        public decimal SellPrice { get; set; }
    }

    public class UpdateSupplyOrderParameter
    {
        public int BookingId { get; set; }

        public List<ListUpdateSupplyOrderParameter> listUpdateSupplyOrderParameters { get; set; }
    }

    public class ListUpdateSupplyOrderParameter
    {
        public int SupplyId { get; set; }
        public int Quantity { get; set; }
        public decimal SellPrice { get; set; }
    }
}
