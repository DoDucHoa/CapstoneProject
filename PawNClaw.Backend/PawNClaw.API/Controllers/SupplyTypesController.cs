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
    [Route("api/supplytype")]
    [ApiController]
    [Authorize]
    public class SupplyTypesController : ControllerBase
    {
        SupplyTypeService _supplyTypeService;

        public SupplyTypesController(SupplyTypeService supplyTypeService)
        {
            _supplyTypeService = supplyTypeService;
        }

        [HttpGet]
        public IActionResult GetAll()
        {
            try
            {
                return Ok(_supplyTypeService.GetSupplyType());
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
