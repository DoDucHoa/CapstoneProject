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
    [Route("api/admins")]
    [ApiController]
    [Authorize]
    public class AdminsController : ControllerBase
    {
        private readonly AdminService _adminService;
        public AdminsController(AdminService adminService)
        {
            _adminService = adminService;
        }

        [HttpGet]
        [Route("get-admins")]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult GetAdmins([FromQuery] AdminRequestParameter _requestParameter, PagingParameter _paging)
        {
            var data = _adminService.GetAdmins(_requestParameter, _paging);
            return Ok(data);
        }

        [HttpPost]
        [Route("create-admin")]
        [Authorize(Roles = "Admin")]
        public IActionResult Add([FromBody] Admin admin)
        {
            if (_adminService.Add(admin) != -1)
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpPut]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult Update([FromBody] Admin admin)
        {

            if (_adminService.Update(admin))
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpDelete]
        [Route("status-false")]
        [Authorize(Roles = "Admin")]
        public IActionResult Delete(int id)
        {
            if (_adminService.Delete(id))
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpPut]
        [Route("status-true")]
        [Authorize(Roles = "Admin")]
        public IActionResult Restore(int id)
        {

            if (_adminService.Restore(id))
            {
                return Ok();
            }
            return BadRequest();
        }
    }
}
