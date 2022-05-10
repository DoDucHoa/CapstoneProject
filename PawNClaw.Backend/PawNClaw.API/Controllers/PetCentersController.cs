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
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class PetCentersController : ControllerBase
    {
        private readonly SearchService _searchService;

        public PetCentersController(SearchService searchService)
        {
            _searchService = searchService;
        }

        [HttpGet]
        [Route("main-search")]
        public IActionResult GetAccounts([FromBody] SearchRequestModel _searchRequestModel)
        {
            var data = _searchService.MainSearchCenter(_searchRequestModel.City, _searchRequestModel.District,
                                                _searchRequestModel.StartBooking, _searchRequestModel.EndBooking,
                                                _searchRequestModel._petRequests, _searchRequestModel.paging);
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