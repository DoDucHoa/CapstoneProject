using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Database;
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
    //[Authorize]
    public class BookingsController : ControllerBase
    {
        BookingService _bookingService;
        BookingActivityService _bookingActivityService;
        AccountService _accountService;
        NotificationService _notificationService;
        StaffServicecs _staffServices;

        public BookingsController(BookingService bookingService, BookingActivityService bookingActivityService, AccountService accountService, NotificationService notificationService, StaffServicecs staffServicecs)
        {
            _bookingService = bookingService;
            _bookingActivityService = bookingActivityService;
            _accountService = accountService;
            _notificationService = notificationService;
            _staffServices = staffServicecs;
        }

        [HttpPut]
        [Authorize(Roles = "Owner,Staff")]
        public async Task<IActionResult> ConfirmBooking([FromBody] UpdateStatusBookingParameter updateStatusParameter)
        {
            try
            {
                bool create = true;

                if (updateStatusParameter.statusId == 2)
                {
                    create = await _bookingActivityService.CreateBookingActivityAfterConfirm(updateStatusParameter.id);
                }

                if (create)
                {
                    var check = _bookingService.ConfirmBooking(updateStatusParameter.id,
                                                            updateStatusParameter.statusId,
                                                            updateStatusParameter.staffNote);
                    if (check)
                    {
                        var booking = _bookingService.GetBookingById(updateStatusParameter.id);
                        var account = _accountService.GetAccountById(booking.CustomerId);
                        var data = new Dictionary<string, string>() {
                            { "Type", "Booking" },
                            { "BookingId", updateStatusParameter.id+"" }
                        };
                        var title = "Cập nhật đơn hàng";
                        var content = "";
                        switch (updateStatusParameter.statusId)
                        {
                            case 2:
                                content = "Đơn hàng của bạn đã được xác nhận";
                                _notificationService.SendNoti(new List<string> { account.DeviceId }, data, title, content);
                                break;
                            case 3:
                                content = "Đơn hàng của bạn đã được hoàn thành";
                                _notificationService.SendNoti(new List<string> { account.DeviceId }, data, title, content);
                                break;
                            case 4:
                                content = "Đơn hàng của bạn đã bị hủy";
                                _notificationService.SendNoti(new List<string> { account.DeviceId }, data, title, content);
                                break;
                            default:
                                break;
                        }
                        NotificationParameter notification = new NotificationParameter()
                        {
                            actorId = booking.Id,
                            actorType = "Booking",
                            targetId = booking.CustomerId,
                            targetType = "Customer",
                            title = title,
                            content = content,
                            time = DateTime.Now
                        };
                        await _notificationService.AddNotification(notification);

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
        //[Authorize(Roles = "Owner,Staff")]
        public IActionResult GetBookingForStaff([FromQuery] BookingRequestParameter bookingRequestParameter)
        {
            var data = _bookingService.GetBookings(bookingRequestParameter);
            return Ok(data);
        }

        [HttpGet("list")]
        [Authorize(Roles = "Owner,Staff")]
        public IActionResult GetBookingForStaff([FromQuery] BookingRequestParameter bookingRequestParameter, [FromQuery] PagingParameter pagingParameter)
        {
            var values = _bookingService.GetBookings(bookingRequestParameter);
            var data = PagedList<Booking>.ToPagedList(values.AsQueryable(), pagingParameter.PageNumber, pagingParameter.PageSize);
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

        [HttpPut("rating")]
        public IActionResult ratingBooking([FromQuery] int bookingId, [FromQuery] int rating, [FromQuery] string? feedback)
        {
            try
            {
                _bookingService.RatingBooking(bookingId, rating, feedback);
                return Ok();
            }
            catch (Exception ex){
                return BadRequest(ex);
            }
        }


        [HttpGet("customer/{id}")]
        //[Authorize(Roles = "Owner,Staff,Customer")]
        public IActionResult GetBookingByCustomerId(int id, int statusId)
        {
            var data = _bookingService.GetBookingsByCustomerId(id, statusId);
            return Ok(data);
        }

        [HttpGet("for-customer/{id}")]
        //[Authorize(Roles = "Owner,Staff,Customer")]
        public IActionResult GetBookingById(int id)
        {
            var data = _bookingService.GetBookingById(id);
            return Ok(data);
        }

        [HttpGet("for-staff/{id}")]
        //[Authorize(Roles = "Owner,Staff")]
        public IActionResult GetBookingByIdForStaff(int id)
        {
            var data = _bookingService.GetBookingByIdForStaff(id);
            return Ok(data);
        }

        [HttpGet("center/{staffId}")]
        //[Authorize(Roles = "Owner,Staff")]
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
                {
                    //get all staff of center
                    var staffs = _staffServices.GetAllByCenterId(data.CenterId);
                    //get registrationtokens
                    List<string> registrationTokens = new List<string>();
                    foreach (Staff staff in staffs)
                    {
                        registrationTokens.Add(staff.IdNavigation.DeviceId);
                    }
                    //insert data to message
                    var noti = new Dictionary<string, string>() {
                        { "Type", "Booking" },
                    };
                    var title = "Đơn hàng mới";
                    var content = "Trung tâm của bạn vừa có một đơn hàng mới";
                    //send notification
                    _notificationService.SendNoti(registrationTokens, noti, title, content);
                    //add notification to firebase
                    NotificationParameter notification = new NotificationParameter()
                    {
                        actorId = data.Id,
                        actorType = "Booking",
                        targetId = data.CenterId,
                        targetType = "Center",
                        title = title,
                        content = content,
                        time = DateTime.Now
                    };
                    await _notificationService.AddNotification(notification);
                }
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

        [HttpPut("invoice-url/{id}")]
        public IActionResult UpdateInvoiceUrl(int id, [FromBody] UpdateInvoiceUrl InvoiceUrl)
        {
            try
            {
                return Ok(_bookingService.UpdateInvoiceUrl(id, InvoiceUrl.InvoiceUrl));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
