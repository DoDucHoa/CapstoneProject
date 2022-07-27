using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.API.Controllers
{
    [Route("api/prices")]
    [ApiController]
    public class PricesController : ControllerBase
    {
        PriceService _priceService;

        public PricesController(PriceService priceService)
        {
            _priceService = priceService;
        }

        [HttpGet("cagetype")]
        public IActionResult GetPriceByCageType(int id)
        {
            try
            {
                return Ok(_priceService.GetPriceByCageType(id));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpGet("{id}")]
        public IActionResult GetPriceById(int id)
        {
            try
            {
                return Ok(_priceService.GetPriceById(id));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPost]
        public IActionResult CreatePrice(Price price)
        {
            try
            {
                return Ok(_priceService.CreatePrice(price));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPut]
        public IActionResult UpdatePrice(Price price)
        {
            try
            {
                return Ok(_priceService.UpdatePrice(price));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPut("delete/{id}")]
        public IActionResult DeletePrice(int id)
        {
            try
            {
                return Ok(_priceService.DeletePrice(id));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
