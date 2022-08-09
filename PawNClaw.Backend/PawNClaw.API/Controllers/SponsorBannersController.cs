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
    [Route("api/sponsorbanners")]
    [ApiController]
    [Authorize]

    public class SponsorBannersController : ControllerBase
    {
        SponsorBannerService _sponsorBannerService;
        LogsService _logService;
        AccountService _accountService;

        public SponsorBannersController(SponsorBannerService sponsorBannerService, LogsService logsService, AccountService accountService)
        {
            _sponsorBannerService = sponsorBannerService;
            _logService = logsService;
            _accountService = accountService;
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
                await _logService.AddLog(new ActionLogsParameter()
                {
                    Id = (long)sponsorBanner.CreateUser,
                    Name = _accountService.GetAccountById((int)sponsorBanner.CreateUser).Admin.Name,
                    Target = "Sponsor của trung tâm thuộc thương hiệu " + sponsorBanner.BrandId,
                    Type = "Create",
                    Time = DateTime.Now,
                });
                return Ok(await _sponsorBannerService.Create(sponsorBanner));
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPut]
        public async Task<IActionResult> Update(UpdateSponsorBanner sponsorBanner)
        {
            try
            {
                await _logService.AddLog(new ActionLogsParameter()
                {
                    Id = (long)sponsorBanner.ModifyUser,
                    Name = _accountService.GetAccountById((int)sponsorBanner.ModifyUser).Admin.Name,
                    Target = "Sponsor của trung tâm thuộc thương hiệu " + sponsorBanner.BrandId,
                    Type = "Update",
                    Time = DateTime.Now,
                });
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
