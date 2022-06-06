using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Parameter;
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
        public IActionResult ConfirmBooking([FromBody] UpdateStatusBookingParameter updateStatusParameter)
        {
            var check = _bookingService.ConfirmBooking(updateStatusParameter.id,
                                                        updateStatusParameter.statusId,
                                                        updateStatusParameter.staffNote);
            if (check)
            {
                return Ok();
            }
            else return BadRequest();
        }

        [HttpGet]
        [Authorize(Roles = "Owner,Staff")]
        public IActionResult GetBookingForStaff([FromQuery] BookingRequestParameter bookingRequestParameter)
        {
            var data = _bookingService.GetBookings(bookingRequestParameter);
            return Ok(data);
        }

        [HttpGet("customer/{id}")]
        [Authorize(Roles = "Owner,Staff,Customer")]
        public IActionResult GetBookingByCustomerId(int id)
        {
            var data = _bookingService.GetBookingsByCustomerId(id);
            return Ok(data);
        }

        [HttpGet("for-customer/{id}")]
        [Authorize(Roles = "Owner,Staff,Customer")]
        public IActionResult GetBookingById(int id)
        {
            var data = _bookingService.GetBookingById(id);
            return Ok(data);
        }

        [HttpGet("for-staff/{id}")]
        [Authorize(Roles = "Owner,Staff")]
        public IActionResult GetBookingByIdForStaff(int id)
        {
            var data = _bookingService.GetBookingByIdForStaff(id);
            return Ok(data);
        }

        [HttpGet("center/{id}")]
        [Authorize(Roles = "Owner,Staff")]
        public IActionResult GetBookingByCenterIdForStaff(int id, int statusId)
        {
            var data = _bookingService.GetBookingsForStaffMobile(id, statusId);
            return Ok(data);
        }

        [HttpPost]
        public async Task<IActionResult> CreateBooking([FromBody] BookingControllerParameter bookingControllerParameter)
        {
            var data = await _bookingService.CreateBooking(bookingControllerParameter.bookingCreateParameter,
                bookingControllerParameter.bookingDetailCreateParameters,
                bookingControllerParameter.serviceOrderCreateParameters,
                bookingControllerParameter.supplyOrderCreateParameters);
            if (data == null)
            {
                return BadRequest();
            }
            else
            return Ok(data);
        }
    }
}
