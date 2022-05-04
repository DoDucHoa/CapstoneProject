using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    public class AccountRequestParameter
    {
        public int? Id { get; set; } = null;
        public string UserName { get; set; } = null;
        public int? CreatedUser { get; set; } = null;
        public bool? Status { get; set; } = null;
        public string RoleCode { get; set; } = null;
        public string DeviceId { get; set; } = null;
        public string Phone { get; set; } = null;

        public string dir { get; set; } = "asc";
        public string sort { get; set; } = null;
        public string fields { get; set; } = null;
        public string includeProperties { get; set; } = null;
    }
}
