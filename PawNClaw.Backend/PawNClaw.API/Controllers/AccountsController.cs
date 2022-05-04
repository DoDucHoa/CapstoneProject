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
        [Route("get-for-admin")]
        [Authorize(Roles = "Admin")]
        public IActionResult GetAccount([FromQuery] AccountRequestParameter _requestParameter, PagingParameter _paging)
        {
            var data = _accountService.GetAccounts(_requestParameter, _paging);
            return Ok(data);
        }

        [HttpGet]
        [Route("get-for-mod")]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult GetAccountForMod([FromQuery] AccountRequestParameter _requestParameter, PagingParameter _paging)
        {
            if (_requestParameter.RoleCode.Trim().Equals("01") || _requestParameter.RoleCode.Trim().Equals("02")) return BadRequest();
            var data = _accountService.GetAccounts(_requestParameter, _paging);
            return Ok(data);
        }

        [HttpPost]
        [Route("create-for-admin")]
        [Authorize(Roles = "Admin")]
        public IActionResult Add(Account account)
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
        public IActionResult AddForMod(Account account)
        {
            if (account.RoleCode.Trim().Equals("01") || account.RoleCode.Trim().Equals("02")) return BadRequest();
            if (_accountService.Add(account) != -1)
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpPut]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult Update(Account account)
        {

            if (_accountService.Update(account))
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpDelete]
        [Route("status-false")]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult Delete(int id)
        {
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
