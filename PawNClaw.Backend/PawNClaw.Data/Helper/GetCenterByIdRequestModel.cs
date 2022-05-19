using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Helper
{
    public class GetCenterByIdRequestModel
    {
        public int id { get; set; }
        public List<List<PetRequestParameter>> _petRequests { get; set; }
    }
}
