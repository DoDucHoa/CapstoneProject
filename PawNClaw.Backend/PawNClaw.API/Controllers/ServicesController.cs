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
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class ServicesController : ControllerBase
    {
        ServiceServices _serviceServices;

        public ServicesController(ServiceServices serviceServices)
        {
            _serviceServices = serviceServices;
        }

        [HttpGet("center")]
        public IActionResult GetServicesOfCenter([FromQuery] ServiceRequestParameter serviceRequestParameter, [FromQuery] PagingParameter paging)
        {
            var data = _serviceServices.GetServices(serviceRequestParameter, paging);
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

        [HttpGet("{id}")]
        public IActionResult GetService(int id)
        {
            try
            {
                return Ok(_serviceServices.GetService(id));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPost]
        public async Task<IActionResult> CreateService([FromBody] CreateServiceParameter createServiceParameter)
        {
            try
            {
                var data = await _serviceServices.CreateService(createServiceParameter.service, createServiceParameter.servicePrice);
                return Ok(data);
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPut]
        public IActionResult UpdateService([FromBody] UpdateServiceParameter service)
        {
            try
            {
                return Ok(_serviceServices.UpdateService(service.serviceP, service.updateServicePrices));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPut("delete/{id}")]
        public IActionResult UpdateService(int id)
        {
            try
            {
                return Ok(_serviceServices.DeleteService(id));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
