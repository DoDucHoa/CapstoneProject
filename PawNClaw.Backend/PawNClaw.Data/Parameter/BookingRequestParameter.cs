using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    public class BookingRequestParameter
    {
        public int? Id { get; set; } = null;
        public int? StatusId { get; set; } = null;
        public int? CustomerId { get; set; } = null;
        public int? CenterId { get; set; } = null;
        public int? Month { get; set; } = null;
        public int? Year { get; set; } = null;
        public DateTime? StartBooking { get; set; }
        public DateTime? EndBooking { get; set; }

        public string dir { get; set; } = "asc";
        public string sort { get; set; } = "CreateTime";
        public string fields { get; set; } = null;
        public string includeProperties { get; set; } = null;
    }

    public class UpdateStatusBookingParameter
    {
        public int id { get; set; }
        public int statusId { get; set; }
        public string staffNote { get; set; } = null;
    }
    
    public class CheckSizePet
    {
        public List<PetRequestForSearchCenter> petRequestForSearchCenters { get; set; }
        public string CageCode { get; set; }
        public int CenterId { get; set; }
        public int BookingId { get; set; }
    }
}
