using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    class RevenueParameter
    {
    }

    public class BookingCount
    {
        public int TotalBooking { get; set; }
    }

    public class BookingCountWithStatus
    {
        public int TotalPending { get; set; }
        public int TotalProcessing { get; set; }
        public int TotalDone { get; set; }
        public int TotalCancelled { get; set; }
    }

    public class TotalCageOfCenter
    {
        public int TotalCage { get; set; }
    }

    public class IncomeOfCenter
    {
        public decimal? IncomeOfMonth { get; set; }
        public decimal? IncomeOfYear { get; set; }
        public float? PercentWithLastMonth { get; set; }
    }
}
