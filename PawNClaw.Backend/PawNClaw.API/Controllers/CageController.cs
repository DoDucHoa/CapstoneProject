using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.API.Controllers
{
    [Route("api/cages")]
    [ApiController]
    [Authorize]
    public class CageController : ControllerBase
    {
        CageService _cageService;

        public CageController(CageService cageService)
        {
            _cageService = cageService;
        }

        [HttpGet]
        [Authorize(Roles = "Owner,Staff")]
        public IActionResult GetCages([FromQuery] CageRequestParameter _requestParameter, [FromQuery] PagingParameter _paging)
        {
            var data = _cageService.getCages(_requestParameter, _paging);
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

        [HttpPost("shift-cages")]
        [Authorize(Roles = "Owner,Staff")]
        public IActionResult ShiftCagesBetweenOnlAndOff([FromBody] ShiftCageParameter requestParameter)
        {
            var data = _cageService.ShiftCage(requestParameter.CageCodes, requestParameter.CenterId);

            return Ok(data);
        }
    }
}
