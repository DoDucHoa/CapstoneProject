using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    public class LocationRequestParameter
    {
        public int? Id { get; set; } = null;
        public string Longtitude { get; set; } = null;
        public string Latitude { get; set; } = null;
        public int? CityId { get; set; } = null;
        public int? DistrictId { get; set; } = null;
        public int? WardId { get; set; } = null;
    }
}
