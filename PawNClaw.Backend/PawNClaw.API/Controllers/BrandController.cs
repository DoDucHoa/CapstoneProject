using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Parameter;

namespace PawNClaw.API.Controllers
{
    [Route("api/brands")]
    [ApiController]
    [Authorize]
    public class BrandController : ControllerBase
    {
        private readonly BrandService _BrandService;

        public BrandController(BrandService BrandService)
        {
            _BrandService = BrandService;
        }

        [HttpGet]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult GetBrands([FromQuery] string Name, [FromQuery] bool? Status, [FromQuery] string dir, [FromQuery] PagingParameter _paging)
        {
            var data = _BrandService.GetBrands(Name, Status, dir, _paging);
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

        [HttpGet("{id}")]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult GetBrandById(int id)
        {
            var data = _BrandService.GetBrandById(id);
            return Ok(data);
        }

        [HttpPost]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult Add([FromBody] CreateBrandParameter brand)
        {
            if (_BrandService.Add(brand) != -1)
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult Update(int id, [FromBody] BrandRequestParameter brand)
        {
            var brandDb = _BrandService.GetBrandById(id);
            brandDb.Name = brand.Name;
            brandDb.Description = brand.Description;

            if (_BrandService.Update(brandDb))
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult Delete(int id)
        {
            if (_BrandService.Delete(id))
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpPut("restore/{id}")]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult Restore(int id)
        {
            if (_BrandService.Restore(id))
            {
                return Ok();
            }
            return BadRequest();
        }
    }
}