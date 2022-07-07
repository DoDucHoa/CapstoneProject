using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class PhotoService
    {
        IPhotoRepository _photoRepository;

        public PhotoService(IPhotoRepository photoRepository)
        {
            _photoRepository = photoRepository;
        }

        public bool UploadPhoto(CreatePhotoParameter createPhotoParameter)
        {
            try
            {
                _photoRepository.CreatePhotos(createPhotoParameter);
                _photoRepository.SaveDbChange();

                return true;
            }
            catch
            {
                throw new Exception();
            }
        }

        public bool UpdatePhoto(UpdatePhotoParameter updatePhotoParameter)
        {
            try
            {
                var photo = _photoRepository.Get(updatePhotoParameter.Id);

                photo.Url = updatePhotoParameter.Url;

                _photoRepository.Update(photo);
                _photoRepository.SaveDbChange();

                return true;
            }
            catch
            {
                throw new Exception();
            }
        }

        public bool DeletePhoto(int id)
        {
            try
            {
                _photoRepository.Remove(id);
                _photoRepository.SaveDbChange();

                return true;
            }
            catch
            {
                throw new Exception();
            }
        }
    }
}
