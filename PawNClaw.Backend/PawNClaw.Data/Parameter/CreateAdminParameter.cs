using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    public class CreateAdminParameter
    {
        public string UserName { get; set; }
        public int CreatedUser { get; set; }
        public string Phone { get; set; }
        public readonly string RoleCode = "MOD";

        public string Name { get; set; }
    }
}
