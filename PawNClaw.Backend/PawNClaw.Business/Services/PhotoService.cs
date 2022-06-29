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
    }
}
