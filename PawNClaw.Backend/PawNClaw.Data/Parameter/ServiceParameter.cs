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

    public class CreateService
    {
        public int? Id { get; set; }
        public string Description { get; set; }
        public decimal? DiscountPrice { get; set; }
        public DateTime? CreateDate { get; set; }
        public DateTime? ModifyDate { get; set; }
        public int? CreateUser { get; set; }
        public int? ModifyUser { get; set; }
        public bool? Status { get; set; }
        public int CenterId { get; set; }
        public string Name { get; set; }
    }

    public class CreateServiceParameter
    {
        public CreateService service { get; set; }
        public List<CreateServicePrice> servicePrice { get; set; }
    }
}
