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
    [Route("api/cagetypes")]
    [ApiController]
    [Authorize]
    public class CageTypesController : ControllerBase
    {
        CageTypeService _cageTypeService;

        public CageTypesController(CageTypeService cageTypeService)
        {
            _cageTypeService = cageTypeService;
        }

        [HttpGet("center/{id}")]
        public IActionResult GetCageTypes(int id, [FromQuery] PagingParameter paging)
        {
            var data = _cageTypeService.GetCageTypes(id, paging);
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

        [HttpPost("staff-booking")]
        [Authorize(Roles = "Owner,Staff")]
        public IActionResult GetCageTypeValidPetSizeAndBookingTime([FromBody] RequestCageTypeForBookingParameter requestCageTypeForBookingParameter)
        {
            var data = _cageTypeService.GetCageTypeWithCageValidPetSizeAndBookingTime(requestCageTypeForBookingParameter.CenterId,
                requestCageTypeForBookingParameter.listPets,
                requestCageTypeForBookingParameter.StartBooking,
                requestCageTypeForBookingParameter.EndBooking);

            return Ok(data);
        }

        [HttpPost]
        [Authorize(Roles = "Owner,Staff")]
        public IActionResult Create([FromBody] CreateCageTypeFlowParameter createCageTypeFlowParameter)
        {
            try
            {
                return Ok(_cageTypeService.CreateCageType(createCageTypeFlowParameter.createCageTypeParameter, createCageTypeFlowParameter.createPriceParameters));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
