using PawNClaw.Data.Database;

namespace PawNClaw.Data.Interface
{
    public interface IBrandRepository : IRepository<Brand>
    {
        public Brand GetBrandById(int id);

        public Brand GetBrandByOwner(int OwnerId);
    }
}
