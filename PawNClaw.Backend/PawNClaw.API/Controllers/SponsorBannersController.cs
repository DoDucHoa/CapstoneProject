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

        [HttpPost]
        public IActionResult Create(SponsorBanner sponsorBanner)
        {
            try
            {
                return Ok(_sponsorBannerService.Create(sponsorBanner));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPut]
        public IActionResult Update(SponsorBanner sponsorBanner)
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
