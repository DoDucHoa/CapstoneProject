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

    public class SupplyRequestParameter
    {
        public int CenterId { get; set; }
        public string? Name { get; set; }
        public bool? Status { get; set; }
        public string? TypeCode { get; set; }

        public string dir { get; set; } = "asc";
        public string sort { get; set; } = null;
        public string fields { get; set; } = null;
        public string includeProperties { get; set; } = null;
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
