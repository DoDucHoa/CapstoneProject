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
    [Route("api/supplies")]
    [ApiController]
    [Authorize]
    public class SuppliesController : ControllerBase
    {
        SupplyService _supplyService;

        public SuppliesController(SupplyService supplyService)
        {
            _supplyService = supplyService;
        }

        [HttpGet("center")]
        public IActionResult GetSupplysOfCenter([FromQuery]int CenterId, [FromQuery] PagingParameter paging)
        {
            try
            {
                var data = _supplyService.GetSupplysOfCenter(CenterId, paging);
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
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpGet("{id}")]
        public IActionResult GetSupply(int id)
        {
            try
            {
                return Ok(_supplyService.GetSupply(id));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPost]
        public IActionResult CreateSupply([FromBody] Supply supply)
        {
            try
            {
                return Ok(_supplyService.CreateSupply(supply));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPut]
        public IActionResult UpdateSupply([FromBody] UpdateSupplyParameter updateSupplyParameter)
        {
            try
            {
                return Ok(_supplyService.UpdateSupply(updateSupplyParameter));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
