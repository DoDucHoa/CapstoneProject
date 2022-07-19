using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.API.Controllers
{
    [Route("api/petbookingdetails")]
    [ApiController]
    [Authorize]
    public class PetBookingDetailsController : ControllerBase
    {
        PetBookingDetailService _petBookingDetailService;

        public PetBookingDetailsController(PetBookingDetailService petBookingDetailService)
        {
            _petBookingDetailService = petBookingDetailService;
        }

        [HttpGet("{id}")]
        public IActionResult GetPetBookingDetailsById(int id)
        {
            var data = _petBookingDetailService.GetPetBookingDetailsByBookingId(id);

            if (data == null)
            {
                return BadRequest();
            }
            else
                return Ok(data);
        }
    }
}
