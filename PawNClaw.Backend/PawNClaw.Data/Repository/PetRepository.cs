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
    }
}
