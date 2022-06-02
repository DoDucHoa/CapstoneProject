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
    [Route("api/pets")]
    [ApiController]
    [Authorize]
    public class PetsController : ControllerBase
    {
        private readonly PetService _petService;
        public PetsController(PetService petService)
        {
            _petService = petService;
        }

        [HttpGet("{id}")]
        public IActionResult GetPetsByCusId(int id, [FromQuery] PagingParameter paging)
        {
            var data = _petService.GetsPetByCusId(id, paging);
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

        [HttpPut]
        [Authorize("Staff")]
        public IActionResult UpdatePetForStaff(UpdatePetRequestParameter updatePetRequestParameter)
        {
            var values = _petService.UpdatePetForStaff(updatePetRequestParameter.Id,
                                                        updatePetRequestParameter.Weight,
                                                        updatePetRequestParameter.Length,
                                                        updatePetRequestParameter.Height);

            if (values)
            {
                return Ok();
            }
            else
            {
                return BadRequest();
            }
        }
    }
}
