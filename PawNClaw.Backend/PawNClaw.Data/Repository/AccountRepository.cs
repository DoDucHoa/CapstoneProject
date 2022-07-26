using Microsoft.EntityFrameworkCore;
using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class AccountRepository : Repository<Account>, IAccountRepository
    {
        private readonly ApplicationDbContext _db;

        public AccountRepository(ApplicationDbContext db) : base(db)
        {
            _db = db;
        }

        public Account GetAccountWithInFor(int id)
        {
            Account query = _dbSet
                .Include(x => x.Admin)
                .Include(x => x.Owner)
                .Include(x => x.Customer)
                .Include(x => x.StaffIdNavigation).First(x => x.Id == id);

            return query;
        }
    }
}
