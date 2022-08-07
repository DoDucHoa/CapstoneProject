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
    [Route("api/sponsorbanners")]
    [ApiController]
    [Authorize]

    public class SponsorBannersController : ControllerBase
    {
        SponsorBannerService _sponsorBannerService;

        public SponsorBannersController(SponsorBannerService sponsorBannerService)
        {
            _sponsorBannerService = sponsorBannerService;
        }

        [HttpGet]
        public IActionResult GetSponsorBanners()
        {
            try
            {
                return Ok(_sponsorBannerService.GetSponsorBanners());
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpGet("all")]
        public IActionResult GetAllBanner([FromQuery] int? id, [FromQuery] PagingParameter pagingParameter)
        {
            try
            {
                var values = _sponsorBannerService.GetBanners();

                if(id != null)
                {
                    values = values.Where(x => x.Id == id);
                }

                var data = PagedList<SponsorBanner>.ToPagedList(values.AsQueryable(),
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

        [HttpPost]
        public async Task<IActionResult> Create(CreateSponsorBanner sponsorBanner)
        {
            try
            {
                return Ok(await _sponsorBannerService.Create(sponsorBanner));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPut]
        public IActionResult Update(UpdateSponsorBanner sponsorBanner)
        {
            try
            {
                return Ok(_sponsorBannerService.Update(sponsorBanner));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPut("deactivate/{id}")]
        public IActionResult Deactivate(int id)
        {
            try
            {
                return Ok(_sponsorBannerService.Deactivate(id));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
