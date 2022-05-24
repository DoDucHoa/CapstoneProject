using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class SupplyRepository : Repository<Supply>, ISupplyRepository
    {
        public SupplyRepository(ApplicationDbContext db) : base(db)
        {
        }
    }
}
