using PawNClaw.Data.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    class ServiceParameter
    {
    }

    public class ServiceRequestParameter
    {
        public int CenterId { get; set; }
        public string? Name { get; set; }
        public bool? Status { get; set; }
        public int? Id { get; set; }

        public string dir { get; set; } = "asc";
        public string sort { get; set; } = null;
        public string fields { get; set; } = null;
        public string includeProperties { get; set; } = null;
    }

    public class CreateServiceParameter
    {
        public CreateService service { get; set; }
        public List<CreateServicePrice> servicePrice { get; set; }
    }
}
