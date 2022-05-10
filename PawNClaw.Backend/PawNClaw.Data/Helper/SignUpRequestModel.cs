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
        public AccountRequestParameter _accountRequest { get; set; }
        public CustomerRequestParameter _customerRequest { get; set; }
    }
}
