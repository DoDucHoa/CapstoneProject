using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.API.Controllers
{
    [Route("api/policies")]
    [ApiController]
    public class PoliciesController : ControllerBase
    {
        PolicyService _policyService;

        public PoliciesController(PolicyService policyService)
        {
            _policyService = policyService;
        }
    }
}
