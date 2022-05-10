using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class CageRepository : Repository<Cage>, ICageRepository
    {
        private readonly ApplicationDbContext _db;

        public CageRepository(ApplicationDbContext db) : base(db)
        {
            _db = db;
        }

        public int CountCageByCageTypeIDExceptBusyCage(int Id, List<string> cageCodesInvalid)
        {
            IQueryable<Cage> query = _dbSet;
            return query.Where(x => x.CageTypeId == Id
                                && !cageCodesInvalid.Contains(x.Code) && x.IsOnline == true).Count();
        }
    }
}
