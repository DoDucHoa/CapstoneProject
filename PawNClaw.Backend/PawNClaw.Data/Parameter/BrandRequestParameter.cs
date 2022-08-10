using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    public class BrandRequestParameter
    {
        public string Name { get; set; } = null;
        public string Description { get; set; } = null;
        public int OwnerId { get; set; } = 0;
        public int ModifyUser { get; set; }
    }
}