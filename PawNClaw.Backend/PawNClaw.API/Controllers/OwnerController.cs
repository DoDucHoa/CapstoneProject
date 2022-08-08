using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Parameter;
using System;

namespace PawNClaw.API.Controllers
{
    [Route("api/owners")]
    [ApiController]
    [Authorize]
    public class OwnerController : ControllerBase
    {
        private readonly OwnerService _OwnerService;

        public OwnerController(OwnerService OwnerService)
        {
            _OwnerService = OwnerService;
        }

        [HttpGet]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult GetOwners([FromQuery] string Name, [FromQuery] bool? Status, [FromQuery] string dir, [FromQuery] string sort, [FromQuery] PagingParameter _paging)
        {
            var data = _OwnerService.GetOwners(Name, Status, dir, sort, _paging);
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
        public IActionResult GetOwnerById(int id)
        {
            var data = _OwnerService.GetOwnerById(id);
            return Ok(data);
        }

        [HttpPost]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult Add([FromBody] CreateOwnerParameter owner)
        {
            try
            {
                var result = _OwnerService.Add(owner);
                return Ok(result);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult Update(int id, [FromBody] OwnerRequestParameter owner)
        {
            var ownerDb = _OwnerService.GetOwnerById(id);
            ownerDb.Email = owner.Email;
            ownerDb.Name = owner.Name;

            if (_OwnerService.Update(ownerDb, owner.Phone))
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult Delete(int id)
        {
            if (_OwnerService.Delete(id))
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpPut("restore/{id}")]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult Restore(int id)
        {
            if (_OwnerService.Restore(id))
            {
                return Ok();
            }
            return BadRequest();
        }
    }
}