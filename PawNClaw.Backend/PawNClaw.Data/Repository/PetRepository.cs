using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class PetRepository : Repository<Pet>, IPetRepository
    {
        private readonly ApplicationDbContext _db;

        public PetRepository(ApplicationDbContext db) : base(db)
        {
            _db = db;
        }

        public IEnumerable<Pet> GetPetByCustomer(int CusId)
        {
            IQueryable<Pet> query = _dbSet;

            query = query.Where(x => x.CustomerId == CusId);

            return query.ToList();
        }

        public bool UpdatePetForStaff(int id, decimal? Weight, decimal? Lenght, decimal? Height)
        {
            Pet query = _dbSet.Find(id);

            if (Weight != null)
            {
                query.Weight = (decimal)Weight;
            }
            if (Lenght != null)
            {
                query.Length = (decimal)Lenght;
            }
            if (Height != null)
            {
                query.Height = (decimal)Height;
            }

            try
            {
                _dbSet.Update(query);
                return (_db.SaveChanges() >= 0);
            }
            catch
            {
                return false;
            }
        }
    }
}
