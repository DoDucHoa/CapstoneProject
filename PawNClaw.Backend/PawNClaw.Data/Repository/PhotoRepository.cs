using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class PhotoRepository : Repository<Photo>, IPhotoRepository
    {
        private readonly ApplicationDbContext _db;

        public PhotoRepository(ApplicationDbContext db) : base(db)
        {
            _db = db;
        }
    }
}
