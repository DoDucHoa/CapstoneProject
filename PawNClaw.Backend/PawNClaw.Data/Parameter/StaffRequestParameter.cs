using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    public class StaffRequestParameter
    {
        
    }

    public class CreateStaffParameter
    {
        public int CenterId { get; set; }
        public int CreateUser { get; set; }
        public string Name { get; set; }
        public string UserName { get; set; }
        public string Phone { get; set; }
        public string RoleCode = "STF";
    }
}
