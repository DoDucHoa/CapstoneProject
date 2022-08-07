using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.API.Controllers
{
    [Route("api/vouchertypes")]
    [ApiController]
    public class VoucherTypesController : ControllerBase
    {
        VoucherTypeService _voucherTypeService;

        public VoucherTypesController(VoucherTypeService voucherTypeService)
        {
            _voucherTypeService = voucherTypeService;
        }

        [HttpGet]
        public IActionResult GetAll()
        {
            try
            {
                return Ok(_voucherTypeService.GetAll());
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
