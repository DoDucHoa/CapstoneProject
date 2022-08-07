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
        public int customerId { get; set; }
        public List<List<PetRequestParameter>> _petRequests { get; set; }
        public string StartBooking { get; set; }
        public string EndBooking { get; set; }
    }

    public class SearchNearbyCenterModel
    {
        public string userLatitude { get; set; }
        public string userLongtitude { get; set; }
    }

    public class GetCenterByIdAfterSearchnameRequestModel
    {
        public int id { get; set; }
        public int customerId { get; set; }
        public List<List<PetRequestParameter>> _petRequests { get; set; }
        public string StartBooking { get; set; }
        public int Due { get; set; }
    }
}
