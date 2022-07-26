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

    public class CreateServiceParameter
    {
        public Service service { get; set; }
        public ServicePrice servicePrice { get; set; }
    }
}
