using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
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

        public void CreatePhotos(CreatePhotoParameter createPhotoParameter)
        {
            Photo photo = new Photo();
            photo.PhotoTypeId = createPhotoParameter.PhotoTypeId;
            photo.IdActor = (int)createPhotoParameter.IdActor;
            photo.Url = createPhotoParameter.Url;
            photo.IsThumbnail = createPhotoParameter.IsThumbnail;
            photo.Status = true;

            _dbSet.Add(photo);

        }

        public IEnumerable<Photo> GetPhotosByIdActorAndPhotoType(int IdActor, int PhotoType)
        {
            IQueryable<Photo> query = _dbSet.Where(x => x.IdActor == IdActor && x.PhotoTypeId == PhotoType && x.Status == true);

            return query.ToList();
        }
    }
}
