using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.API.Controllers
{
    [Route("api/accounts")]
    [ApiController]
    [Authorize]
    public class AccountsController : ControllerBase
    {
        private readonly AccountService _accountService;
        private readonly OwnerService _ownerService;
        private readonly AdminService _adminService;
        private readonly StaffServicecs _staffServicecs;
        private readonly CustomerService _customerService;

        public AccountsController(AccountService accountService, OwnerService ownerService,
            AdminService adminService, StaffServicecs staffServicecs,
            CustomerService customerService)
        {
            _accountService = accountService;
            _ownerService = ownerService;
            _adminService = adminService;
            _staffServicecs = staffServicecs;
            _customerService = customerService;
        }

        [HttpGet("{id:int}")]
        public IActionResult GetAccount(int id)
        {
            var data = _accountService.GetAccountById(id);
            return Ok(data);
        }

        [HttpGet]
        [Authorize(Roles = "Admin")]
        public IActionResult GetAccounts([FromQuery] AccountRequestParameter _requestParameter, [FromQuery] PagingParameter _paging)
        {
            var data = _accountService.GetAccounts(_requestParameter, _paging);
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

        [HttpGet("customer")]
        public IActionResult GetAccountsCustomer([FromQuery] AccountRequestParameter _requestParameter, [FromQuery] PagingParameter _paging)
        {
            var data = _accountService.GetAccountsCus(_requestParameter, _paging);
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

        [HttpPost]
        [Authorize(Roles = "Admin")]
        public IActionResult Add([FromBody] Account account)
        {
            if (account.RoleCode.Trim().Equals("01")) return BadRequest();
            if (_accountService.Add(account) != -1)
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpPost]
        [Route("create-for-mod")]
        [Authorize(Roles = "Admin,Moderator")]
        public IActionResult AddForMod([FromBody] Account account)
        {
            if (account.RoleCode.Trim().Equals("01") || account.RoleCode.Trim().Equals("02")) return BadRequest();
            if (_accountService.Add(account) != -1)
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpPut("{id:int}")]
        public IActionResult Update(int id, [FromBody] AccountRequestParameter account)
        {
            var accountDb = _accountService.GetAccountById(id);
            accountDb.DeviceId = account.DeviceId;
            accountDb.RoleCode = account.RoleCode;
            if (_accountService.Update(accountDb))
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpPut]
        public IActionResult Update([FromBody] UpdateAccountParam param)
        {
            if (_accountService.Update(param.account))
            {
                try
                {
                    if (param.account.RoleCode.Equals("AD"))
                    {
                        _adminService.Update(param.admin);
                    }
                    if (param.account.RoleCode.Equals("CUS"))
                    {
                        _customerService.Update(param.customer);
                    }
                    if (param.account.RoleCode.Equals("MOD"))
                    {
                        _adminService.Update(param.admin);
                    }
                    if (param.account.RoleCode.Equals("OWN"))
                    {
                        _ownerService.Update(param.owner);
                    }
                    if (param.account.RoleCode.Equals("STF"))
                    {
                        _staffServicecs.Update(param.staff);
                    }

                    return Ok();

                }
                catch (Exception ex)
                {
                    return BadRequest(ex);
                }
                
            }
            return BadRequest();
        }

        [HttpDelete("{id:int}")]
        [Authorize(Roles = "Admin,Moderator")]
        public IActionResult DeleteForMod(int id)
        {
            if (_accountService.GetAccountById(id).RoleCode.Trim().Equals("AD") ||
                _accountService.GetAccountById(id).RoleCode.Trim().Equals("MOD"))
            {
                ModelState.AddModelError("Id", "ID is Mod or Admin account");
                return BadRequest(ModelState);
            }
            if (_accountService.Delete(id))
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpDelete("admin/{id:int}")]
        [Authorize(Roles = "Admin")]
        public IActionResult Delete(int id)
        {
            if (_accountService.GetAccountById(id).RoleCode.Trim().Equals("AD"))
            {
                ModelState.AddModelError("Id", "ID is Admin account");
                return BadRequest(ModelState);
            }
            if (_accountService.Delete(id))
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpPut("restore/{id:int}")]
        [Authorize(Roles = "Admin,Moderator")]
        public IActionResult Restore(int id)
        {

            if (_accountService.Restore(id))
            {
                return Ok();
            }
            return BadRequest();
        }
    }
}
