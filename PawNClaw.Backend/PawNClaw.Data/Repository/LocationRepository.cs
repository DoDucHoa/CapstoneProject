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
    public class LocationRepository : Repository<Location>, ILocationRepository
    {
        private readonly ApplicationDbContext _db;

        public LocationRepository(ApplicationDbContext db) : base(db)
        {
            _db = db;
        }

        public IEnumerable<Location> getAllWithCenter()
        {
            var values = _dbSet.Include(x => x.IdNavigation).Select(x => new Location()
            {
                Id = x.Id,
                Latitude = x.Latitude,
                Longtitude = x.Longtitude,
                IdNavigation = x.IdNavigation
            }).ToList();

            return values;

        }
    }
}
