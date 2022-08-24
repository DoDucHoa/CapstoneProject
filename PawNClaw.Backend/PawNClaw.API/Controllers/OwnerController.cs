using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Parameter;
using System;
using System.Threading.Tasks;

namespace PawNClaw.API.Controllers
{
    [Route("api/owners")]
    [ApiController]
    [Authorize]
    public class OwnerController : ControllerBase
    {
        private readonly OwnerService _OwnerService;
        private LogsService _logService;
        private AccountService _accountService;

        public OwnerController(OwnerService OwnerService, LogsService logsService, AccountService accountService)
        {
            _OwnerService = OwnerService;
            _logService = logsService;
            _accountService = accountService;
        }

        [HttpGet]
        [Authorize(Roles = "Admin,Moderator")]
        public IActionResult GetOwners([FromQuery] string Name, [FromQuery] bool? Status, [FromQuery] string dir, [FromQuery] string sort, [FromQuery] bool? isLookup, [FromQuery] PagingParameter _paging)
        {
            var data = _OwnerService.GetOwners(Name, Status, dir, sort, isLookup, _paging);
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
        [Authorize(Roles = "Admin,Moderator")]
        public async Task<IActionResult> Add([FromBody] CreateOwnerParameter owner)
        {
            try
            {
                var result = _OwnerService.Add(owner);
                await _logService.AddLog(new ActionLogsParameter()
                {
                    Id = owner.CreatedUser,
                    Name = _accountService.GetAccountById(owner.CreatedUser).Admin.Name,
                    Target = "Owner " + owner.Name,
                    Type = "Create",
                    Time = DateTime.Now,
                });
                return Ok(result);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpPut("{id}")]
        //[Authorize(Roles = "Admin,Moderator")]
        public async Task<IActionResult> Update(int id, [FromBody] OwnerRequestParameter owner)
        {
            var ownerDb = _OwnerService.GetOwnerByIdForUpdate(id);
            ownerDb.Name = owner.Name;
            ownerDb.Gender = owner.Gender;

            if (_OwnerService.Update(ownerDb, owner.Phone))
            {
                if(owner.ModifyUser != id)
                {

                    await _logService.AddLog(new ActionLogsParameter()
                    {
                        Id = (long)owner.ModifyUser,
                        Name = _accountService.GetAccountById(owner.ModifyUser).Admin.Name,
                        Target = "Owner " + owner.Name,
                        Type = "Update",
                        Time = DateTime.Now,
                    });
                }
                return Ok();
            }
            return BadRequest();
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin,Moderator")]
        public async Task<IActionResult> Delete(int id)
        {
            if (await _OwnerService.Delete(id))
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpPut("restore/{id}")]
        [Authorize(Roles = "Admin,Moderator")]
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