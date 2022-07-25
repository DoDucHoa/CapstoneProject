using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Parameter;

namespace PawNClaw.API.Controllers
{
    [Route("api/petcenters")]
    [ApiController]
    [Authorize]
    public class PetCentersController : ControllerBase
    {
        private readonly PetCenterService _petCenterService;
        private readonly SearchService _searchService;

        public PetCentersController(SearchService searchService, PetCenterService petCenterService)
        {
            _searchService = searchService;
            _petCenterService = petCenterService;
        }

        [HttpPost]
        [Route("main-search")]
        public async Task<IActionResult> GetAccountsAsync([FromBody] SearchRequestModel _searchRequestModel)
        {
            try
            {
                var data = await _searchService.ReferenceCenter(_searchRequestModel.City, _searchRequestModel.District,
                                                _searchRequestModel.StartBooking, _searchRequestModel.Due,
                                                _searchRequestModel._petRequests, _searchRequestModel.paging);

                if (data.petCenters.Count == 0)
                {
                    return Ok("No Response!!!");
                }

                var metadata = new
                {
                    data.petCenters.TotalCount,
                    data.petCenters.PageSize,
                    data.petCenters.CurrentPage,
                    data.petCenters.TotalPages,
                    data.petCenters.HasNext,
                    data.petCenters.HasPrevious
                };

                return Ok(new { data, metadata });
            }
            catch (Exception ex)
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

        [HttpPost]
        [Route("check_center")]
        public async Task<IActionResult> GetCenterByIdAfterSearch([FromBody] GetCenterByIdAfterSearchnameRequestModel model)
        {
            try
            {
                var data = _searchService.CheckCenter(model.id, model._petRequests, model.StartBooking, model.Due);

                if (data == null)
                {
                    var referenceCenter = await _searchService.SearchCenterNearByCenterId(model.id, model.StartBooking, model.Due, model._petRequests);

                    var addition = new
                    {
                        mess = "Reference Center!!!"
                    };
                    return Ok(new { referenceCenter,  addition});
                }

                return Ok(data);
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpGet]
        public IActionResult GetCenters([FromQuery] string name, [FromQuery] bool? status, [FromQuery] string sort, [FromQuery] PagingParameter paging, string includeProperties)
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

        [HttpGet("{id:int}")]
        public IActionResult GetCenter(int id)
        {
            var data = _petCenterService.GetById(id);
            return Ok(data);
        }

        [HttpGet("staff/{id:int}")]
        public IActionResult GetCenterByStaffId(int id)
        {
            var data = _petCenterService.GetByStaffId(id);
            return Ok(data);
        }

        [HttpGet("detail/{id:int}")]
        public IActionResult GetCenterById(int id)
        {
            var data = _petCenterService.GetDetailByCenterId(id);
            return Ok(data);
        }

        [HttpGet("brand/{id:int}")]
        public IActionResult GetCentersByBrand(int id)
        {
            var data = _petCenterService.GetByBrand(id);
            
            return Ok(data);
        }

        [HttpPost]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult Create([FromBody] PetCenterRequestParameter petCenterRequestParameter)
        {
            var petCenter = new PetCenter
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
            return BadRequest();
        }

        [HttpPut]
        public IActionResult Update([FromBody] PetCenterRequestParameter petCenterRequestParameter)
        {
            var petCenter = _petCenterService.GetById((int)petCenterRequestParameter.Id);

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
            return BadRequest();
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult Delete(int id)
        {
            if (_petCenterService.Delete(id))
                return Ok();
            return BadRequest();
        }

        [HttpPut("restore/{id}")]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult Restore(int id)
        {
            if (_petCenterService.Restore(id))
                return Ok();
            return BadRequest();
        }

        [HttpGet]
        [Route("search-name")]
        public IActionResult SearchByName(string name, [FromQuery] PagingParameter paging)
        {
            var data = _searchService.SearchCenterByName(name, paging);

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
    }
}