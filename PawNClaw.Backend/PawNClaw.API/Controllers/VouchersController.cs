using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.API.Controllers
{
    [Route("api/vouchers")]
    [ApiController]
    [Authorize]
    public class VouchersController : ControllerBase
    {
        VoucherService _voucherService;

        public VouchersController(VoucherService voucherService)
        {
            _voucherService = voucherService;
        }

        [HttpGet("for-cus/center/{id}")]
        public IActionResult GetVouchersIsAvaliable(int centerId)
        {
            try
            {
                return Ok(_voucherService.GetVouchersIsAvaliable(centerId));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpGet("for-staff/center/{id}")]
        public IActionResult GetVouchers(int centerId)
        {
            try
            {
                return Ok(_voucherService.GetVouchers(centerId));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpGet("{code}")]
        public IActionResult GetVoucher(string code)
        {
            try
            {
                return Ok(_voucherService.GetVoucher(code));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPost]
        public IActionResult CreateVouchers(Voucher voucher)
        {
            try
            {
                return Ok(_voucherService.CreateVouchers(voucher));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPut]
        public IActionResult UpdateVoucher(Voucher voucher)
        {
            try
            {
                return Ok(_voucherService.UpdateVoucher(voucher));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
