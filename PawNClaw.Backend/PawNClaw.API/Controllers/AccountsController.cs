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

        public AccountsController(AccountService accountService)
        {
            _accountService = accountService;
        }

        [HttpGet]
        [Route("get-by-id")]
        public IActionResult GetAccount(int id)
        {
            var data = _accountService.GetAccountById(id);
            return Ok(data);
        }

        [HttpGet]
        [Route("get-for-admin")]
        [Authorize(Roles = "Admin")]
        public IActionResult GetAccounts([FromQuery] AccountRequestParameter _requestParameter, PagingParameter _paging)
        {
            var data = _accountService.GetAccounts(_requestParameter, _paging);
            return Ok(data);
        }

        [HttpGet]
        [Route("get-for-mod")]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult GetAccountsForMod([FromQuery] AccountRequestParameter _requestParameter, PagingParameter _paging)
        {
            if (_requestParameter.RoleCode.Trim().Equals("01") || _requestParameter.RoleCode.Trim().Equals("02")) return BadRequest();
            var data = _accountService.GetAccounts(_requestParameter, _paging);
            return Ok(data);
        }

        [HttpPost]
        [Route("create-for-admin")]
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
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult AddForMod([FromBody] Account account)
        {
            if (account.RoleCode.Trim().Equals("01") || account.RoleCode.Trim().Equals("02")) return BadRequest();
            if (_accountService.Add(account) != -1)
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpPut]
        public IActionResult Update([FromBody] Account account)
        {

            if (_accountService.Update(account))
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpDelete]
        [Route("status-false-mod")]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult DeleteForMod(int id)
        {
            if (_accountService.GetAccountById(id).RoleCode.Trim().Equals("01") ||
                _accountService.GetAccountById(id).RoleCode.Trim().Equals("02"))
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

        [HttpDelete]
        [Route("status-false-admin")]
        [Authorize(Roles = "Admin")]
        public IActionResult Delete(int id)
        {
            if (_accountService.GetAccountById(id).RoleCode.Trim().Equals("01"))
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

        [HttpPut]
        [Route("status-true")]
        [Authorize(Roles = "Admin,Mod")]
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
