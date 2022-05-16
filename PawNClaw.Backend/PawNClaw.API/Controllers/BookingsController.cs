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
    [Route("api/bookings")]
    [ApiController]
    [Authorize]
    public class BookingsController : ControllerBase
    {
        BookingService _bookingService;

        public BookingsController(BookingService bookingService)
        {
            _bookingService = bookingService;
        }

        [HttpPut]
        [Authorize(Roles = "Owner,Staff")]
        public IActionResult ConfirmBooking(int id, int statusId)
        {
            var check = _bookingService.ConfirmBooking(id, statusId);
            if (check)
            {
                return Ok();
            }
            else return BadRequest();
        }
    }
}
