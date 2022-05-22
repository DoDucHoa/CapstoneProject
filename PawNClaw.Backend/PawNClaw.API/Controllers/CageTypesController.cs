﻿using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Helper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.API.Controllers
{
    [Route("api/cagetypes")]
    [ApiController]
    [Authorize]
    public class CageTypesController : ControllerBase
    {
        CageTypeService _cageTypeService;

        public CageTypesController(CageTypeService cageTypeService)
        {
            _cageTypeService = cageTypeService;
        }

        [HttpGet("center/{id}")]
        public IActionResult GetCageTypes(int id, PagingParameter paging)
        {
            var data = _cageTypeService.GetCageTypes(id, paging);
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
    }
}