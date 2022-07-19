using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.API.Controllers
{
    [Route("api/bookingdetails")]
    [ApiController]
    [Authorize]
    public class BookingDetailsController : ControllerBase
    {
        BookingDetailService _bookingDetailService;

        public BookingDetailsController(BookingDetailService bookingDetailService)
        {
            _bookingDetailService = bookingDetailService;
        }

        [HttpGet("{id}")]
        public IActionResult GetByBookingId(int id)
        {
            var data = _bookingDetailService.GetBookingDetailsByBookingId(id);
            if (data == null)
            {
                return NotFound();
            } else
            {
                return Ok(data);
            }
        }

        [HttpGet]
        public IActionResult GetByBookingIdAndLine(int id)
        {
            var data = _bookingDetailService.GetBookingDetailsById(id);
            if (data == null)
            {
                return NotFound();
            }
            else
            {
                return Ok(data);
            }
        }

        [HttpPut]
        [Authorize(Roles = "Owner,Staff")]
        public async Task<ActionResult> UpdateCageBookingDetail( [FromBody] UpdateBookingDetailParameter updateBookingDetailParameter)
        {
            try
            {
                var data = await _bookingDetailService.UpdateCageOfBookingDetail(updateBookingDetailParameter);

                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
