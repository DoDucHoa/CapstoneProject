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
        BookingActivityService _bookingActivityService;

        public BookingsController(BookingService bookingService, BookingActivityService bookingActivityService)
        {
            _bookingService = bookingService;
            _bookingActivityService = bookingActivityService;
        }

        [HttpPut]
        [Authorize(Roles = "Owner,Staff")]
        public async Task<IActionResult> ConfirmBooking([FromBody] UpdateStatusBookingParameter updateStatusParameter)
        {
            try
            {
                var create = await _bookingActivityService.CreateBookingActivityAfterConfirm(updateStatusParameter.id);

                if (create)
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
                else return BadRequest();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
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
        public IActionResult GetBookingByCustomerId(int id, int statusId)
        {
            var data = _bookingService.GetBookingsByCustomerId(id, statusId);
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

        [HttpGet("center/{staffId}")]
        [Authorize(Roles = "Owner,Staff")]
        public IActionResult GetBookingByCenterIdForStaff(int staffId, int? statusId)
        {
            var data = _bookingService.GetBookingsForStaffMobile(staffId, statusId);
            return Ok(data);
        }

        [HttpPost]
        public async Task<IActionResult> CreateBooking([FromBody] BookingControllerParameter bookingControllerParameter)
        {
            try
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
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPost("check-size")]
        public IActionResult CheckCage([FromBody] CheckSizePet checkSizePet)
        {
            try
            {
                var data = _bookingService.CheckSizePet(checkSizePet.petRequestForSearchCenters, checkSizePet.CageCode, checkSizePet.CenterId);
                return Ok(data);
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpGet("get-booking-cagecode")]
        public IActionResult TestGet(int CenterId, int? StatusId, string CageCode)
        {
            try
            {
                return Ok(_bookingService.GetBookingByCageCode(CenterId, StatusId, CageCode));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
