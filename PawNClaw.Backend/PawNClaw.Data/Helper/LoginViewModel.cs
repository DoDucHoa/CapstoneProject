using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Helper
{
    public class LoginViewModel
    {
        public string JwtToken { get; set; }
        public int Id { get; set; }
        public string UserName { get; set; }
        public string Name { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public string Role { get; set; }
        public string Url { get; set; }

        public LoginViewModel()
        {
        }
    }
}
