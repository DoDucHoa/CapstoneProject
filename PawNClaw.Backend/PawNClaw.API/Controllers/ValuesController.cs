using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Parameter;
using PawNClaw.Data.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ValuesController : ControllerBase
    {
        SearchService service;

        PriceRepository priceRepository;

        BookingService bookingService;

        public ValuesController(SearchService service, PriceRepository priceRepository, BookingService bookingService)
        {
            this.service = service;
            this.priceRepository = priceRepository;
            this.bookingService = bookingService;
        }

        [HttpGet]
        [Route("TestTokenAdmin")]
        [Authorize(Roles = "Admin")]
        public IActionResult TestAuthToken()
        {
            return Ok("Admin-Oke");
        }

        [HttpPost]
        public IActionResult TestGet(int CenterId, int? StatusId, string CageCode)
        {
            return Ok(bookingService.GetBookingByCageCode(CenterId, StatusId, CageCode));
        }
    }
}
