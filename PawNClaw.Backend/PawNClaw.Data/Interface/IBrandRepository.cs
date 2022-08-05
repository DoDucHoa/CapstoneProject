using PawNClaw.Data.Database;
using System.Collections.Generic;

namespace PawNClaw.Data.Interface
{
    public interface IBrandRepository : IRepository<Brand>
    {
        public Brand GetBrandById(int id);

        public Brand GetBrandByOwner(int OwnerId);

        public IEnumerable<Brand> GetBrands();
    }
}
