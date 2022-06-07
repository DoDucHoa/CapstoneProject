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
    [Route("api/pethealthhistorys")]
    [ApiController]
    [Authorize]
    public class PetHealthHistorysController : ControllerBase
    {
        PetHealthHistoryService _petHealthHistoryService;

        public PetHealthHistorysController(PetHealthHistoryService petHealthHistoryService)
        {
            _petHealthHistoryService = petHealthHistoryService;
        }

        [HttpPost]
        [Authorize(Roles = "Owner,Staff")]
        public async Task<ActionResult> CreatePetHealthHistory( [FromBody] CreateUpdatePetHealthHistoryParameter createUpdatePetHealthHistoryParameter)
        {
            var data = await _petHealthHistoryService.CreatePetHealthHistory(createUpdatePetHealthHistoryParameter);

            if (data)
            {
                return Ok();
            }
            else
                return BadRequest();
        }
    }
}
