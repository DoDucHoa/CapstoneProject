using Microsoft.EntityFrameworkCore;
using PawNClaw.Data.Const;
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

        PhotoRepository _photoRepository;

        public LocationRepository(ApplicationDbContext db, PhotoRepository photoRepository) : base(db)
        {
            _db = db;
            _photoRepository = photoRepository;
        }

        public IEnumerable<Location> getAllWithCenter()
        {
            var values = _dbSet.Include(x => x.IdNavigation).ThenInclude(x => x.Bookings).Where(x => x.IdNavigation.Status == true).Select(x => new Location()
            {
                Id = x.Id,
                Latitude = x.Latitude,
                Longtitude = x.Longtitude,
                IdNavigation = new PetCenter()
                {
                    Id = x.Id,
                    Name = x.IdNavigation.Name,
                    Address = x.IdNavigation.Address,
                    Phone = x.IdNavigation.Phone,
                    Rating = x.IdNavigation.Rating,
                    CreateDate = x.IdNavigation.CreateDate,
                    Status = x.IdNavigation.Status,
                    OpenTime = x.IdNavigation.OpenTime,
                    CloseTime = x.IdNavigation.CloseTime,
                    Description = x.IdNavigation.Description,
                    BrandId = x.IdNavigation.BrandId,
                    Bookings = x.IdNavigation.Bookings,
                    Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(x.Id, PhotoTypesConst.PetCenter)
                },
            }).ToList();

            return values;

        }
    }
}
