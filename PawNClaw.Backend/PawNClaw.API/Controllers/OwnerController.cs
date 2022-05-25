using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

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
        public IActionResult GetModerators([FromQuery] string Name, [FromQuery] bool? Status, [FromQuery] string dir, [FromQuery] string sort, [FromQuery] PagingParameter _paging)
        {
            var data = _OwnerService.GetModerators(Name, Status, dir, sort, _paging);
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
        /*
        [HttpGet("{id}")]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult GetAdminById(int id)
        {
            var data = _OwnerService.GetAdminById(id);
            return Ok(data);
        }

        [HttpPost]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult Add([FromBody] CreateAdminParameter admin)
        {
            if (_OwnerService.Add(admin) != -1)
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult Update(int id, [FromBody] AdminRequestParameter admin)
        {
            var adminDb = _OwnerService.GetAdminById(id);
            adminDb.Email = admin.Email;
            adminDb.Name = admin.Name;

            if (_OwnerService.Update(adminDb, admin.Phone))
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
        */
    }
}
