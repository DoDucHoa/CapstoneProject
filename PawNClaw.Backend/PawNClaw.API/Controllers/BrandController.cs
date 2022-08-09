using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Parameter;
using System;
using System.Threading.Tasks;

namespace PawNClaw.API.Controllers
{
    [Route("api/brands")]
    [ApiController]
    [Authorize]
    public class BrandController : ControllerBase
    {
        private readonly BrandService _brandService;
        private LogsService _logService;
        private AccountService _accountService;
        public BrandController(BrandService brandService, LogsService logsService, AccountService accountService)
        {
            _brandService = brandService;
            _logService = logsService;
            _accountService = accountService;
        }

        [HttpGet]
        [Authorize(Roles = "Admin,Moderator")]
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
        public IActionResult GetBrandById(int id)
        {
            try
            {
                var data = _brandService.GetBrandById(id);
                return Ok(data);
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPost]
        [Authorize(Roles = "Admin,Moderator")]
        public async Task<IActionResult> Add([FromBody] CreateBrandParameter brand)
        {
            try
            {
                await _logService.AddLog(new ActionLogsParameter(){ 
                    Id =  brand.CreateUser,
                    Name = _accountService.GetAccountById(brand.CreateUser).Admin.Name,
                    Target = "Brand "+brand.Name,
                    Type = "Create",
                    Time = DateTime.Now,
                });
                return Ok(_brandService.Add(brand));
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpPut("{id:int}")]
        public async Task<IActionResult> Update([FromRoute] int id, [FromBody] BrandRequestParameter brand)
        {
            var brandDb = _brandService.GetBrandById(id);
            brandDb.Name = brand.Name;
            brandDb.Description = brand.Description;
            brandDb.OwnerId = brand.OwnerId;
            brandDb.ModifyUser = brand.ModifyUser;

            if (_brandService.Update(brandDb))
            {
                await _logService.AddLog(new ActionLogsParameter()
                {
                    Id = brand.ModifyUser,
                    Name = _accountService.GetAccountById(brand.ModifyUser).Admin.Name,
                    Target = "Brand " + brand.Name,
                    Type = "Update",
                    Time = DateTime.Now,
                });
                return Ok();
            }
            return BadRequest();
        }

        [HttpDelete("{id:int}")]
        [Authorize(Roles = "Admin,Moderator")]
        public IActionResult Delete(int id)
        {
            if (_brandService.Delete(id))
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpPut("restore/{id:int}")]
        [Authorize(Roles = "Admin,Moderator")]
        public IActionResult Restore(int id)
        {
            if (_brandService.Restore(id))
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpGet("owner/{id:int}")]
        [Authorize(Roles = "Admin,Moderator,Owner")]
        public IActionResult GetBrandByOwnerId(int id)
        {
            try
            {
                return Ok(_brandService.GetBrandByOwnerId(id));
            }
            catch(Exception ex)
            {
                return BadRequest(ex);
            }
        }

    }
}