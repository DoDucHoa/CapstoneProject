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
    [Route("api/revenuereportowners")]
    [ApiController]
    [Authorize]
    public class RevenueReportOwnersController : ControllerBase
    {
        RevenueReportOwnerService _service;

        public RevenueReportOwnersController(RevenueReportOwnerService service)
        {
            _service = service;
        }

        [HttpGet("booking-count")]
        public IActionResult BookingCount(int centerId, DateTime? from, DateTime? to)
        {
            try
            {
                return Ok(_service.BookingCount(centerId, from, to));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpGet("booking-count-status")]
        public IActionResult BookingCountWithStatus(int centerId, DateTime? from, DateTime? to)
        {
            try
            {
                return Ok(_service.BookingCountWithStatus(centerId, from, to));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpGet("total-cage")]
        public IActionResult TotalCageOfCenter(int centerId, DateTime? from, DateTime? to)
        {
            try
            {
                return Ok(_service.TotalCageOfCenter(centerId, from, to));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpGet("cage-free-list")]
        public IActionResult CageFreeOfCenter(int centerId, DateTime? from, DateTime? to)
        {
            try
            {
                return Ok(_service.CageFreeOfCenter(centerId, from, to));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpGet("income")]
        public IActionResult IncomeOfCenter(int centerId)
        {
            try
            {
                return Ok(_service.IncomeOfCenter(centerId));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpGet("income-cusdate")]
        public IActionResult IncomeOfCenterCustomeMonth(int centerId, DateTime date)
        {
            try
            {
                return Ok(_service.IncomeOfCenterCustomeMonth(centerId, date));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
