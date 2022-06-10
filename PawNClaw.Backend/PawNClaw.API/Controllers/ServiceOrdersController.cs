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
    [Route("api/serviceorders")]
    [ApiController]
    [Authorize]
    public class ServiceOrdersController : ControllerBase
    {
        ServiceOrderService _serviceOrderService;

        public ServiceOrdersController(ServiceOrderService serviceOrderService)
        {
            _serviceOrderService = serviceOrderService;
        }

        [HttpPut]
        public async Task<ActionResult> UpdateServiceOrderForStaff( [FromBody] UpdateServiceOrderParameter updateServiceOrderParameter)
        {
            var data = await _serviceOrderService.UpdateServiceOrderForStaff(updateServiceOrderParameter);

            if (data)
            {
                return Ok();
            }
            else
                return BadRequest();
        }

        [HttpPost]
        public async Task<ActionResult> CreateServiceOrder( [FromBody] AddNewServiceOrderParameter addNewServiceOrderParameter)
        {
            var data = await _serviceOrderService.CreateServiceOrder(addNewServiceOrderParameter);
            if (data)
            {
                return Ok();
            }
            else
                return BadRequest();
        }
    }
}
