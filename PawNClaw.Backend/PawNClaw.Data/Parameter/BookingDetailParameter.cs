using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    class BookingDetailParameter
    {
    }

    public class UpdateBookingDetailParameter
    {
        public int BookingId { get; set; }
        public int Line { get; set; }
        public decimal Price { get; set; }
        public string CageCode { get; set; }
        public string Note { get; set; }
    }
}
