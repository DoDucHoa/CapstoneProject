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
    [Route("api/pricetypes")]
    [ApiController]
    //[Authorize]
    public class PriceTypeController : ControllerBase
    {
        PriceTypeService _priceTypeService;

        public PriceTypeController(PriceTypeService priceTypeService)
        {
            _priceTypeService = priceTypeService;
        }

        [HttpGet]
        //Authorize(Roles = "Owner,Staff,Admin,Mod")]
        public IActionResult GetAllPriceTypes()
        {
            var data = _priceTypeService.getPriceTypes();
            
            return Ok(data);
        }
    }
}
