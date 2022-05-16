using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.API.Controllers
{
    [Route("api/districts")]
    [ApiController]
    [Authorize]
    public class DistrictsController : ControllerBase
    {
        DistrictService _districtService;

        public DistrictsController(DistrictService districtService)
        {
            _districtService = districtService;
        }

        [HttpGet("{id}")]
        public IActionResult GetDistrictsByCity(string id)
        {
            return Ok(_districtService.GetDistricts(id));
        }
    }
}
