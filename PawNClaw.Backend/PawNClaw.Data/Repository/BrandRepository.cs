using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Helper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace PawNClaw.Data.Repository
{
    public class BrandRepository : Repository<Brand>, IBrandRepository
    {
        public BrandRepository(ApplicationDbContext db) : base(db)
        {
        }
        public Brand GetBrandById(int id)
        {
            return _dbSet.Include(x => x.Owner).ThenInclude(y => y.IdNavigation).FirstOrDefault(brand => brand.Id == id);
        }

        public Brand GetBrandByOwner(int OwnerId)
        {
            return _dbSet.Include(x => x.PetCenters).FirstOrDefault(brand => brand.OwnerId == OwnerId);
        }
    }
}
