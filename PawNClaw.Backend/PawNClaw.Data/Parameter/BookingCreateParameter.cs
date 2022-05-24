using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    public class BookingCreateParameter
    {
        public DateTime? CreateTime { get; set; }
        public DateTime? StartBooking { get; set; }
        public DateTime? EndBooking { get; set; }
        public int StatusId { get; set; } = 1;
        public string VoucherCode { get; set; }
        public int CustomerId { get; set; }
        public int CenterId { get; set; }
        public string CustomerNote { get; set; }
    }

    public class BookingDetailCreateParameter
    {
        public decimal? Price { get; set; }
        public string CageCode { get; set; }
        public decimal? Duration { get; set; }
        public string Note { get; set; }
        public List<int> PetId { get; set; }
    }

    public class ServiceOrderCreateParameter
    {
        public int ServiceId { get; set; }
        public int? Quantity { get; set; }
        public decimal? SellPrice { get; set; }
        public string Note { get; set; }
        public int PetId { get; set; }
    }

    public class SupplyOrderCreateParameter
    {
        public int SupplyId { get; set; }
        public int? Quantity { get; set; }
        public decimal? SellPrice { get; set; }
        public decimal? TotalPrice { get; set; }
        public string Note { get; set; }
        public int PetId { get; set; }
    }

    public class BookingControllerParameter
    {
        public BookingCreateParameter bookingCreateParameter { get; set; }
        public List<BookingDetailCreateParameter> bookingDetailCreateParameters { get; set; }
        public List<ServiceOrderCreateParameter> serviceOrderCreateParameters { get; set; }
        public List<SupplyOrderCreateParameter> supplyOrderCreateParameters { get; set; }
    }
}
