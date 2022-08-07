using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Const;
using PawNClaw.Data.Parameter;
using PawNClaw.Data.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;

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
        //[Authorize(Roles = "Admin")]
        public async Task<IActionResult> TestAuthTokenAsync(string newPolicy)
        {
            var data = await PolicyService.GetAllPolicy("pawnclaw-4b6ba");
            return Ok(data);
        }

        [HttpPost]
        public IActionResult TestGet(int CenterId, int? StatusId, string CageCode)
        {
            return Ok(bookingService.GetBookingByCageCode(CenterId, StatusId, CageCode));
        }

        [HttpGet("test-geo")]
        public async Task<IActionResult> TestGeo(string address)
        {
            var client = new HttpClient();
            string url = "https://rsapi.goong.io/geocode?address=" + HttpUtility.UrlEncode(address) + SearchConst.GoongAPIKey;
            Console.WriteLine(url);
            HttpResponseMessage response = await client.GetAsync(url);
            response.EnsureSuccessStatusCode();

            var result = await response.Content.ReadAsStringAsync();

            return Ok(result);
        }
    }
}
