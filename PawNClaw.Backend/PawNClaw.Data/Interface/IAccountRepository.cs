using PawNClaw.Data.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Interface
{
    public interface IAccountRepository : IRepository<Account>
    {
        public Account GetAccountWithInFor(int id);

        public IEnumerable<Account> GetCustomerAccount();
    }
}
