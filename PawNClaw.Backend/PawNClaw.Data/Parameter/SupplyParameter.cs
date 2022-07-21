using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    class SupplyParameter
    {

    }

    public class UpdateSupplyParameter
    {
        public int Id { get; set; }
        public decimal SellPrice { get; set; }
        public decimal? DiscountPrice { get; set; }
        public int Quantity { get; set; }
        public DateTime? ModifyDate { get; set; }
        public int? ModifyUser { get; set; }
        public bool? Status { get; set; }
    }
}
