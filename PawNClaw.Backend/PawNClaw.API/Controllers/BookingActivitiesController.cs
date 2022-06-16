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
    [Route("api/bookingactivities")]
    [ApiController]
    [Authorize]
    public class BookingActivitiesController : ControllerBase
    {
        BookingActivityService _bookingActivityService;

        public BookingActivitiesController(BookingActivityService bookingActivityService)
        {
            _bookingActivityService = bookingActivityService;
        }

        [HttpPost]
        [Authorize(Roles = "Owner,Staff")]
        public async Task<ActionResult> CreateBookingActivity([FromBody] CreateBookingActivityControllerParameter createBookingActivityControllerParameter)
        {
            try
            {
                await _bookingActivityService.CreateBookingActivity(createBookingActivityControllerParameter);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
