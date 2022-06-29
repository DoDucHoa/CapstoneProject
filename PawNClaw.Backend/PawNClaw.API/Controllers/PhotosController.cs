using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Const;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.API.Controllers
{
    [Route("api/photos")]
    [ApiController]
    [Authorize]
    public class PhotosController : ControllerBase
    {
        PhotoService _photoService;

        public PhotosController(PhotoService photoService)
        {
            _photoService = photoService;
        }

        [HttpPost("brand")]
        public IActionResult UpLoadBrandPhoto(CreatePhotoParameter createPhotoParameter)
        {
            try
            {
                createPhotoParameter.PhotoTypeId = PhotoTypesConst.Brand;

                _photoService.UploadPhoto(createPhotoParameter);

                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPost("petcenter")]
        public IActionResult UpLoadPetCenterPhoto(CreatePhotoParameter createPhotoParameter)
        {
            try
            {
                createPhotoParameter.PhotoTypeId = PhotoTypesConst.PetCenter;

                _photoService.UploadPhoto(createPhotoParameter);

                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPost("cage")]
        public IActionResult UpLoadCagePhoto(CreatePhotoParameter createPhotoParameter)
        {
            try
            {
                createPhotoParameter.PhotoTypeId = PhotoTypesConst.Cage;

                _photoService.UploadPhoto(createPhotoParameter);

                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPost("pet")]
        public IActionResult UpLoadPetPhoto(CreatePhotoParameter createPhotoParameter)
        {
            try
            {
                createPhotoParameter.PhotoTypeId = PhotoTypesConst.PetProfile;

                _photoService.UploadPhoto(createPhotoParameter);

                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPost("banner")]
        public IActionResult UpLoadBannerPhoto(CreatePhotoParameter createPhotoParameter)
        {
            try
            {
                createPhotoParameter.PhotoTypeId = PhotoTypesConst.Banner;

                _photoService.UploadPhoto(createPhotoParameter);

                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPost("service")]
        public IActionResult UpLoadServicePhoto(CreatePhotoParameter createPhotoParameter)
        {
            try
            {
                createPhotoParameter.PhotoTypeId = PhotoTypesConst.Service;

                _photoService.UploadPhoto(createPhotoParameter);

                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPost("supply")]
        public IActionResult UpLoadSupplyPhoto(CreatePhotoParameter createPhotoParameter)
        {
            try
            {
                createPhotoParameter.PhotoTypeId = PhotoTypesConst.Supply;

                _photoService.UploadPhoto(createPhotoParameter);

                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
