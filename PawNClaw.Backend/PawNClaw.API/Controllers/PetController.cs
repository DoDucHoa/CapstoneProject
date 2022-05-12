using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Helper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.API.Controllers
{
    [Route("api/pets")]
    [ApiController]
    [Authorize]
    public class PetController : ControllerBase
    {
        private readonly PetService _petService;
        public PetController(PetService petService)
        {
            _petService = petService;
        }

        [HttpGet("{id}")]
        public IActionResult GetPetsByCusId(int Id, [FromQuery] PagingParameter paging)
        {
            var data = _petService.GetsPetByCusId(Id, paging);
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
    }
}
