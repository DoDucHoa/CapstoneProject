﻿using System;
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
        [Route("nearby_search")]
        public async Task<IActionResult> searchNearbyCenter([FromBody] SearchNearbyCenterModel model) 
        {
            try
            {
                var data = await _searchService.searchNearbyCenter(model.userLongtitude, model.userLatitude);

                return Ok(data);
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
                var data = _petCenterService.GetDetailById(model.id, model.customerId, model._petRequests, model.StartBooking, model.EndBooking);
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
                var data = _searchService.CheckCenter(model.id, model.customerId, model._petRequests, model.StartBooking, model.Due);

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

        [HttpGet("for-admin/{id:int}")]
        public IActionResult GetCenterForAdmin(int id)
        {
            var data = _petCenterService.GetByIdForAdmin(id);
            return Ok(data);
        }

        [HttpPost]
        [Authorize(Roles = "Admin,Mod")]
        public async Task<IActionResult> Create([FromBody] CreatePetCenterParameter parameter)
        {
            var petCenter = new PetCenter
            {
                Name = parameter.Name,
                Address = parameter.Address,
                Phone = parameter.Phone,
                Rating = null,
                CreateDate = DateTime.Now,
                ModifyDate = DateTime.Now,
                CreateUser = parameter.CreateUser,
                ModifyUser = parameter.ModifyUser,
                Status = true,
                BrandId = (int)parameter.BrandId,
                OpenTime = parameter.OpenTime,
                CloseTime = parameter.CloseTime
            };

            var location = new Location
            {
                Longtitude = parameter.Longtitude,
                Latitude = parameter.Latitude,
                CityCode = parameter.CityCode,
                DistrictCode = parameter.DistrictCode,
                WardCode = parameter.WardCode
            };

            try
            {
                var id = await _petCenterService.Add(petCenter, location);

                return Ok(id);
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPut("for-admin")]
        public async Task<IActionResult> UpdateByAdmin([FromBody] UpdatePetCenterForAdminParam petCenterRequestParameter)
        {
            try
            {

                await _petCenterService.UpdateForAdminAsync(petCenterRequestParameter);

                return Ok();
            }
            catch(Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpPut("for-owner")]
        public IActionResult UpdateByOwner([FromBody] UpdatePetCenterForOwnerParam petCenterRequestParameter)
        {
            try
            {

                _petCenterService.UpdateForOwner(petCenterRequestParameter);

                return Ok();
            }
            catch(Exception e)
            {
                return BadRequest(e);
            }

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