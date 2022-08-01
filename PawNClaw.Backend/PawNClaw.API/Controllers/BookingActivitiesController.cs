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
        AccountService _accountService;
        NotificationService _notificationService;

        public BookingActivitiesController(BookingActivityService bookingActivityService, AccountService accountService, NotificationService notificationService)
        {
            _bookingActivityService = bookingActivityService;
            _accountService = accountService;
            _notificationService = notificationService;
        }

        [HttpGet("{id}")]
        public IActionResult getActivityById([FromRoute] int id)
        {
            try
            {
                var data = _bookingActivityService.GetById(id);
                return Ok(data);
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPut]
        [Authorize(Roles = "Owner,Staff")]
        public async Task<ActionResult> UpdateBookingActivity([FromBody] UpdateBookingActivityParameter updateBookingActivityParameter)
        {
            try
            {
                //update activity
                await _bookingActivityService.UpdateActivity(updateBookingActivityParameter);
                
                //get registration token from account
                var registrationToken = _bookingActivityService.GetCustomerByActivityId(updateBookingActivityParameter.Id).DeviceId;

                //create a list of regitration tokens
                List<string> registrationTokens = new List<string>();
                registrationTokens.Add(registrationToken);

                //insert data to message
                var data = new Dictionary<string, string>() {
                    { "Type", "Activity" },
                    { "ActivityId", updateBookingActivityParameter.Id+"" }
                };

                //send notification
                _notificationService.SendNoti(registrationTokens, data, "Hoạt động mới !!!", "Một hoạt động mới cho thú cưng của bạn vừa được cập nhật");

                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
