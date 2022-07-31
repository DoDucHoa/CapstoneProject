using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Const;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = "Admin")]
    public class ConstsController : ControllerBase
    {
        [HttpGet("KmSearch")]
        public async Task<IActionResult> KmSearch()
        {
            try
            {
                var data = await ConstService.Get(Const.ProjectFirebaseId, "Const", "KmSearch");
                return Ok(data);
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPost("KmSearch")]
        public async Task<IActionResult> UpdateKmSearch(string newData)
        {
            try
            {
                await ConstService.AddData(Const.ProjectFirebaseId, "Const", "KmSearch", newData);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpGet("NumOfSponsor")]
        public async Task<IActionResult> NumOfSponsor()
        {
            try
            {
                var data = await ConstService.Get(Const.ProjectFirebaseId, "Const", "NumOfSponsor");
                return Ok(data);
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPost("NumOfSponsor")]
        public async Task<IActionResult> UpdateNumOfSponsor(string newData)
        {
            try
            {
                await ConstService.AddData(Const.ProjectFirebaseId, "Const", "NumOfSponsor", newData);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
