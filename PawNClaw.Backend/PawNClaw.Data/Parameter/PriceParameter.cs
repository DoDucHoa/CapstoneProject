using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    class PriceParameter
    {
    }

    public class CreatePriceParameter
    {
        public decimal UnitPrice { get; set; }
        public DateTime? CreateDate { get; set; }
        public int? CreateUser { get; set; }
        public string PriceTypeCode { get; set; }
    }
}
