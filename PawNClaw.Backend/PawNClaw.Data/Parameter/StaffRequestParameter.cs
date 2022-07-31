using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    public class StaffParameter
    {
        
    }

    public class StaffRequestParameter
    {
        public string? Name { get; set; }
        public int CenterId { get; set; }
        public bool? Status { get; set; } = true;

        public string dir { get; set; } = "asc";
        public string sort { get; set; } = null;
        public string fields { get; set; } = null;
        public string includeProperties { get; set; } = null;
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

    public class UpdateStaffParameter
    {
        public int Id { get; set; }
        public int ModifyUser { get; set; }
        public string Name { get; set; }
        public string Phone { get; set; }
    }
}
