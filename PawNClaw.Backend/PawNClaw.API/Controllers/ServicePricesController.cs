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
    [Route("api/serviceprices")]
    [ApiController]
    [Authorize]
    public class ServicePricesController : ControllerBase
    {
        ServicePriceService _servicePriceService;

        public ServicePricesController(ServicePriceService servicePriceService)
        {
            _servicePriceService = servicePriceService;
        }

        //Get All Price Of Service
        [HttpGet]
        public IActionResult GetPriceOfService(int id)
        {
            var data = _servicePriceService.GetPriceOfService(id);
            if (data != null)
            {
                return Ok(data);
            }
            else
            {
                return BadRequest();
            }
        }
    }
}
