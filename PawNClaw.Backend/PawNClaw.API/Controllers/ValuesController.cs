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

        public ValuesController(SearchService service, PriceRepository priceRepository)
        {
            this.service = service;
            this.priceRepository = priceRepository;
        }

        [HttpGet]
        [Route("TestTokenAdmin")]
        [Authorize(Roles = "Admin")]
        public IActionResult TestAuthToken()
        {
            return Ok("Admin-Oke");
        }
    }
}
