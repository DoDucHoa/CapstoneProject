using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.API.Controllers
{
    [Route("api/supplyorders")]
    [ApiController]
    [Authorize]
    public class SupplyOrdersController : ControllerBase
    {
        SupplyOrderService _supplyOrderService;

        public SupplyOrdersController(SupplyOrderService supplyOrderService)
        {
            _supplyOrderService = supplyOrderService;
        }

        [HttpPut]
        public async Task<ActionResult> UpdateSupplyOrderForStaff(UpdateSupplyOrderParameter updateSupplyOrderParameter)
        {
            var data = await _supplyOrderService.UpdateSupplyOrderForStaff(updateSupplyOrderParameter);

            if (data)
            {
                return Ok();
            }
            else
                return BadRequest();
        }
    }
}
