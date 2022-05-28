using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    public class CreateOwnerParameter
    {
        public string UserName { get; set; }
        public int CreatedUser { get; set; }
        public string Phone { get; set; }
        public int Gender { get; set; }
        public readonly string RoleCode = "OWN";
        public string Name { get; set; }
    }
}
