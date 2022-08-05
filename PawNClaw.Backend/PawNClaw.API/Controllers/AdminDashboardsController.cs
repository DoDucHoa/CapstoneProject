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
    [Route("api/admindashboards")]
    [ApiController]
    [Authorize]
    public class AdminDashboardsController : ControllerBase
    {
        AdminDashboardService _adminDashboardService;

        public AdminDashboardsController(AdminDashboardService adminDashboardService)
        {
            _adminDashboardService = adminDashboardService;
        }

        [HttpGet("center-available")]
        public IActionResult CenterAvailable()
        {
            try
            {
                return Ok(_adminDashboardService.CenterAvailable());
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpGet("brand-available")]
        public IActionResult BrandAvailable()
        {
            try
            {
                return Ok(_adminDashboardService.BrandAvailable());
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpGet("customer-available")]
        public IActionResult CustomerAvailable()
        {
            try
            {
                return Ok(_adminDashboardService.CustomerAvailable());
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
