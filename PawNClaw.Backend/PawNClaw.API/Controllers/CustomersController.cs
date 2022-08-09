using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CustomersController : ControllerBase
    {
        CustomerService customerService;

        public CustomersController(CustomerService customerService)
        {
            this.customerService = customerService;
        }

        [HttpPut("update-status")]
        public IActionResult updateStatus(int id)
        {
            try
            {
                customerService.UpdateStatus(id);
                return Ok();
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

    }
}
