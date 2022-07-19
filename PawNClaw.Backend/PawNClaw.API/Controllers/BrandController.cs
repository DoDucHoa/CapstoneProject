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
        private readonly BrandService _brandService;

        public BrandController(BrandService brandService)
        {
            _brandService = brandService;
        }

        [HttpGet]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult GetBrands([FromQuery] string Name, [FromQuery] bool? Status, [FromQuery] string dir, [FromQuery] PagingParameter _paging)
        {
            var data = _brandService.GetBrands(Name, Status, dir, _paging);
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

        [HttpGet("{id:int}")]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult GetBrandById(int id)
        {
            var data = _brandService.GetBrandById(id);
            return Ok(data);
        }

        [HttpPost]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult Add([FromBody] CreateBrandParameter brand)
        {
            if (_brandService.Add(brand) != -1)
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpPut("{id:int}")]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult Update([FromRoute] int id, [FromBody] BrandRequestParameter brand)
        {
            var brandDb = _brandService.GetBrandById(id);
            brandDb.Name = brand.Name;
            brandDb.Description = brand.Description;
            brandDb.OwnerId = brand.OwnerId;

            if (_brandService.Update(brandDb))
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpDelete("{id:int}")]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult Delete(int id)
        {
            if (_brandService.Delete(id))
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpPut("restore/{id:int}")]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult Restore(int id)
        {
            if (_brandService.Restore(id))
            {
                return Ok();
            }
            return BadRequest();
        }
    }
}