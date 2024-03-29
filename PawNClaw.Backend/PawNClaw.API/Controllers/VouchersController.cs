﻿using Microsoft.AspNetCore.Authorization;
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

        [HttpGet("for-cus/center")]
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

        [HttpGet("for-staff/center")]
        public IActionResult GetVouchers(int centerId, bool? status, string code, bool? isAvalable, [FromQuery] PagingParameter pagingParameter)
        {
            try
            {
                var values = _voucherService.GetVouchers(centerId);

                if (status != null)
                {
                    values = values.Where(x => x.Status == status);
                }
                if (!String.IsNullOrEmpty(code) && !String.IsNullOrWhiteSpace(code))
                {
                    values = values.Where(x => x.Code.ToLower().Contains(code.ToLower()));
                }
                if (isAvalable != null && isAvalable == true)
                {
                    DateTime today = DateTime.Now;

                    values = values.Where(x => x.StartDate <= today && x.ExpireDate >= today && x.ReleaseAmount > 0);
                }

                values = values.OrderByDescending(x => x.ExpireDate);

                var data = PagedList<Voucher>.ToPagedList(values.AsQueryable(),
                pagingParameter.PageNumber,
                10);
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
        public IActionResult CreateVouchers( [FromBody] CreateVoucherParameter voucher)
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
        public IActionResult UpdateVoucher([FromBody] UpdateVoucherParameter voucher)
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

        [HttpPut("update-status")]
        public IActionResult UpdateStatus(string code)
        {
            try
            {
                return Ok(_voucherService.UpdateStatus(code));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
