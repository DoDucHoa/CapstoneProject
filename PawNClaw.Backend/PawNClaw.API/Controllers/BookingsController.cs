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
        public IActionResult ConfirmBooking(int id, int statusId, string StaffNote)
        {
            var check = _bookingService.ConfirmBooking(id, statusId, StaffNote);
            if (check)
            {
                return Ok();
            }
            else return BadRequest();
        }

        [HttpGet]
        public IActionResult GetBookingForStaff([FromQuery] BookingRequestParameter bookingRequestParameter, [FromQuery] PagingParameter paging)
        {
            var data = _bookingService.GetBookings(bookingRequestParameter, paging);
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

        [HttpPost]
        public async Task<IActionResult> CreateBooking([FromBody] BookingControllerParameter bookingControllerParameter)
        {
            var data = await _bookingService.CreateBooking(bookingControllerParameter.bookingCreateParameter,
                bookingControllerParameter.bookingDetailCreateParameters,
                bookingControllerParameter.serviceOrderCreateParameters,
                bookingControllerParameter.supplyOrderCreateParameters);

            return Ok(data);

        }
    }
}
