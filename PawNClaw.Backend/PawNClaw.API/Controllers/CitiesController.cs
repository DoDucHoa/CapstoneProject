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
    [Route("api/cities")]
    [ApiController]
    [Authorize]
    public class CitiesController : ControllerBase
    {
        CityService _cityService;

        public CitiesController(CityService cityService)
        {
            _cityService = cityService;
        }

        [HttpGet]
        public IActionResult GetCity()
        {
            return Ok(_cityService.GetCities());
        }
    }
}
