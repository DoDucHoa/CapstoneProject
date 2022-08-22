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
        public async Task<IActionResult> UpdateBookingActivity([FromBody] UpdateBookingActivityParameter updateBookingActivityParameter)
        {
            try
            {
                //update activity
                await _bookingActivityService.UpdateActivity(updateBookingActivityParameter);

                //get registration token from account
                var customer = _bookingActivityService.GetCustomerByActivityId(updateBookingActivityParameter.Id);
                var registrationToken = customer.DeviceId;

                //create a list of regitration tokens
                List<string> registrationTokens = new List<string>();
                registrationTokens.Add(registrationToken);

                //insert data to message
                var data = new Dictionary<string, string>() {
                    { "Type", "Activity" },
                    { "ActivityId", updateBookingActivityParameter.Id+"" }
                };
                var title = "Hoạt động mới";
                var content = "Một hoạt động mới cho thú cưng của bạn vừa được cập nhật";
                //send notification
                _notificationService.SendNoti(registrationTokens, data, title, content);
                //add notification to firebase
                NotificationParameter notification = new NotificationParameter() { 
                    actorId = updateBookingActivityParameter.Id,
                    actorType = "Activity",
                    targetId = customer.Id,
                    targetType = "Customer",
                    title = title,
                    content = content,
                    time = DateTime.Now
                };
                await _notificationService.AddNotification(notification);

                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
