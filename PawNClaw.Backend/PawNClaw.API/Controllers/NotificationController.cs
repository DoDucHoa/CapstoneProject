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
    [Route("api/notification")]
    [ApiController]
    [Authorize]
    public class NotificationController : ControllerBase
    {
        NotificationService _notificationService;

        public NotificationController(NotificationService notificationService)
        {
            _notificationService = notificationService;
        }

        [HttpGet("for-customer/{id}")]
        public async Task<IActionResult> getNotificationForCustomer([FromRoute] int id)
        {
            try
            {
                var data = await _notificationService.GetNotis(id, "Customer");
                return Ok(data);
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpGet("for-center/{id}")]
        public async Task<IActionResult> getNotificationForCenter([FromRoute] int id)
        {
            try
            {
                var data = await _notificationService.GetNotis(id, "Center");
                return Ok(data);
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
