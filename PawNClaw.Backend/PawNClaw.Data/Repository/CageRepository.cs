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
    public class CageRepository : Repository<Cage>, ICageRepository
    {
        private readonly ApplicationDbContext _db;

        public CageRepository(ApplicationDbContext db) : base(db)
        {
            _db = db;
        }

        public int CountCageByCageTypeIDExceptBusyCage(int Id, bool IsSingle, List<string> cageCodesInvalid)
        {
            IQueryable<Cage> query = _dbSet;
            return query.Include("CageType").Where(x => x.CageTypeId == Id
                                && !cageCodesInvalid.Contains(x.Code) && x.IsOnline == true && x.CageType.IsSingle == IsSingle).Count();
        }

        public Cage GetCageWithCageType(string CageCode, int CenterId)
        {
            Cage query = _dbSet.Include(x => x.CageType)
                .SingleOrDefault(x => x.Code.Trim().Equals(CageCode) && x.CenterId == CenterId);

            return query;
        }
    }
}
