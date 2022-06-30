using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.API.Controllers
{
    [Route("api/petcenters")]
    [ApiController]
    //[Authorize]
    public class PetCentersController : ControllerBase
    {
        private readonly SearchService _searchService;
        private readonly PetCenterService _petCenterService;

        public PetCentersController(SearchService searchService, PetCenterService petCenterService)
        {
            _searchService = searchService;
            _petCenterService = petCenterService;
        }

        [HttpPost]
        [Route("main-search")]
        public IActionResult GetAccounts([FromBody] SearchRequestModel _searchRequestModel)
        {
            try
            {
                var data = _searchService.MainSearchCenter_ver_2(_searchRequestModel.City, _searchRequestModel.District,
                                                _searchRequestModel.StartBooking, _searchRequestModel.Due,
                                                _searchRequestModel._petRequests, _searchRequestModel.paging);

                if (data.Count() == 0)
                {
                    return BadRequest("No Response!!!");
                }

                var metadata = new
                {
                    data.TotalCount,
                    data.PageSize,
                    data.CurrentPage,
                    data.TotalPages,
                    data.HasNext,
                    data.HasPrevious
                };

                return Ok(new { data, metadata });
            }
            catch(Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPost]
        [Route("center_detail")]
        public IActionResult GetCenterByIdWithInclude([FromBody] GetCenterByIdRequestModel model)
        {
            try
            {
                var data = _petCenterService.GetDetailById(model.id, model._petRequests, model.StartBooking, model.EndBooking);
                return Ok(data);
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpGet]
        public IActionResult GetCenters(string includeProperties, PagingParameter paging)
        {
            var data = _petCenterService.GetAll(includeProperties, paging);
            var metadata = new
            {
                data.TotalCount,
                data.PageSize,
                data.CurrentPage,
                data.TotalPages,
                data.HasNext,
                data.HasPrevious
            };
            return Ok(new { data, metadata });
        }

        [HttpGet("{id}")]
        public IActionResult GetCenter(int id)
        {
            var data = _petCenterService.GetById(id);
            return Ok(data);
        }

        [HttpGet("brand/{id}")]
        public IActionResult GetCentersByBrand(int id, PagingParameter paging)
        {
            var data = _petCenterService.GetByBrand(id, paging);
            var metadata = new
            {
                data.TotalCount,
                data.PageSize,
                data.CurrentPage,
                data.TotalPages,
                data.HasNext,
                data.HasPrevious
            };
            return Ok(new { data, metadata });
        }

        [HttpGet("name/{name}")]
        public IActionResult GetCenterByName(string name, PagingParameter paging)
        {
            var data = _petCenterService.GetByName(name, paging);
            var metadata = new
            {
                data.TotalCount,
                data.PageSize,
                data.CurrentPage,
                data.TotalPages,
                data.HasNext,
                data.HasPrevious
            };
            return Ok(new { data, metadata });
        }

        [HttpPost]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult Create([FromBody] PetCenterRequestParameter petCenterRequestParameter)
        {
            PetCenter petCenter = new PetCenter
            {
                Name = petCenterRequestParameter.Name,
                Address = petCenterRequestParameter.Address,
                Phone = petCenterRequestParameter.Phone,
                Rating = null,
                CreateDate = DateTime.Now,
                ModifyDate = null,
                CreateUser = petCenterRequestParameter.CreateUser,
                ModifyUser = null,
                Status = true,
                BrandId = (int)petCenterRequestParameter.BrandId,
                OpenTime = petCenterRequestParameter.OpenTime,
                CloseTime = petCenterRequestParameter.CloseTime
            };
            if (_petCenterService.Add(petCenter) == 1)
                return Ok();
            else
                return BadRequest();
        }

        [HttpPut]
        public IActionResult Update([FromBody] PetCenterRequestParameter petCenterRequestParameter)
        {

            PetCenter petCenter = _petCenterService.GetById((int)petCenterRequestParameter.Id);

            petCenter.Name = petCenterRequestParameter.Name;
            petCenter.Address = petCenterRequestParameter.Address;
            petCenter.Phone = petCenterRequestParameter.Phone;
            petCenter.ModifyDate = DateTime.Now;
            petCenter.ModifyUser = petCenterRequestParameter.ModifyUser;
            petCenter.BrandId = (int)petCenterRequestParameter.BrandId;
            petCenter.OpenTime = petCenterRequestParameter.OpenTime;
            petCenter.CloseTime = petCenterRequestParameter.CloseTime;
            
            if (_petCenterService.Update(petCenter))
                return Ok();
            else
                return BadRequest();
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult Delete(int id)
        {
            if (_petCenterService.Delete(id))
                return Ok();
            else
                return BadRequest();
        }

        [HttpPut("restore/{id}")]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult Restore(int id)
        {
            if (_petCenterService.Restore(id))
                return Ok();
            else
                return BadRequest();
        }
    }
}
