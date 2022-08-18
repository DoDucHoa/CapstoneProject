using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class CancelLogRepository : Repository<CancelLog>, ICancelLogRepository
    {
        public CancelLogRepository(ApplicationDbContext db) : base(db)
        {
        }
    }
}
