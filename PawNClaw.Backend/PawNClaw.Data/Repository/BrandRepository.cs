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
            return _dbSet.Include(x => x.Owner).FirstOrDefault(brand => brand.Id == id);
        }
    }
}
