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
    [Route("api/wards")]
    [ApiController]
    [Authorize]
    public class WardsController : ControllerBase
    {
        WardService _wardService;

        public WardsController(WardService wardService)
        {
            _wardService = wardService;
        }

        [HttpGet("{id}")]
        public IActionResult GetWardsByDistrict(string id)
        {
            try
            {
                return Ok(_wardService.GetWardsByDistrictCode(id));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
