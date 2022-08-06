using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class WardRepository : Repository<Ward>, IWardRepository
    {
        public WardRepository(ApplicationDbContext db) : base(db)
        {
        }
    }
}
