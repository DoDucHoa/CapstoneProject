using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Helper
{
    public class SignUpRequestModel
    {
        public LoginRequestModel _loginRequestModel { get; set; }
        public AccountCreateParameter _accountRequest { get; set; }
        public CustomerCreateParameter _customerRequest { get; set; }
    }

    public class AccountCreateParameter
    {
        public string UserName { get; set; }
        public string RoleCode { get; set; }
        public string DeviceId { get; set; }
        public string Phone { get; set; }
    }

    public class CustomerCreateParameter
    {
        public string Name { get; set; }
        public DateTime? Birth { get; set; }
    }
}
