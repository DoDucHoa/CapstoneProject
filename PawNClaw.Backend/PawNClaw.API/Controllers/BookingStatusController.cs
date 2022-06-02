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
    [Route("api/bookingstatuses")]
    [ApiController]
    [Authorize]
    public class BookingStatusController : ControllerBase
    {
        BookingStatusService _bookingStatusService;

        public BookingStatusController(BookingStatusService bookingStatusService)
        {
            _bookingStatusService = bookingStatusService;
        }

        [HttpGet]
        public IActionResult GetBookingStatuses()
        {
            var data = _bookingStatusService.GetBookingStatuses();

            return Ok(data);
        }
    }
}
