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
        public IActionResult UpLoadBrandPhoto([FromBody] CreatePhotoParameter createPhotoParameter)
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
        public IActionResult UpLoadPetCenterPhoto([FromBody] CreatePhotoParameter createPhotoParameter)
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

        [HttpPost("cagetype")]
        public IActionResult UpLoadCagePhoto([FromBody] CreatePhotoParameter createPhotoParameter)
        {
            try
            {
                createPhotoParameter.PhotoTypeId = PhotoTypesConst.CageType;

                _photoService.UploadPhoto(createPhotoParameter);

                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPost("pet")]
        public IActionResult UpLoadPetPhoto([FromBody] CreatePhotoParameter createPhotoParameter)
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
        public IActionResult UpLoadBannerPhoto([FromBody] CreatePhotoParameter createPhotoParameter)
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
        public IActionResult UpLoadServicePhoto([FromBody] CreatePhotoParameter createPhotoParameter)
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
        public IActionResult UpLoadSupplyPhoto([FromBody] CreatePhotoParameter createPhotoParameter)
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

        [HttpPost("account")]
        public IActionResult UpLoadAccountPhoto([FromBody] CreatePhotoParameter createPhotoParameter)
        {
            try
            {
                createPhotoParameter.PhotoTypeId = PhotoTypesConst.Account;

                _photoService.UploadPhoto(createPhotoParameter);

                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPut]
        public IActionResult UpDateBrandPhoto([FromBody] UpdatePhotoParameter updatePhotoParameter)
        {
            try
            {
                _photoService.UpdatePhoto(updatePhotoParameter);

                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpDelete("{id}")]
        public IActionResult DeletePhoto(int id)
        {
            try
            {
                _photoService.DeletePhoto(id);

                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
