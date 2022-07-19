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
            Cage query = _dbSet
                .Include(x => x.CageType)
                .Select(cage => new Cage
                {
                    Code = cage.Code,
                    CenterId = cage.CenterId,
                    Name = cage.Name,
                    Color = cage.Color,
                    IsOnline = cage.IsOnline,
                    CageType = new CageType
                    {
                        Id = cage.CageType.Id,
                        TypeName = cage.CageType.TypeName,
                        Description = cage.CageType.Description,
                        Height = cage.CageType.Height,
                        Width = cage.CageType.Width,
                        Length = cage.CageType.Length,
                        IsSingle = cage.CageType.IsSingle,
                        Status = cage.CageType.Status
                    }
                })
                .SingleOrDefault(x => x.Code.Trim().Equals(CageCode) && x.CenterId == CenterId);

            return query;
        }

        public Cage GetCage(string Code, int CenterId)
        {
            Cage query = _dbSet.Find(Code, CenterId);

            return query;
        }
    }
}
