using PawNClaw.Data.Database;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Interface
{
    public interface IPhotoRepository : IRepository<Photo>
    {
        public void CreatePhotos(CreatePhotoParameter createPhotoParameter);

        public IEnumerable<Photo> GetPhotosByIdActorAndPhotoType(int IdActor, int PhotoType);
    }
}
