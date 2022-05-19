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

        public string dir { get; set; } = "asc";
        public string sort { get; set; } = "CreateTime";
        public string fields { get; set; } = null;
        public string includeProperties { get; set; } = null;
    }
}
