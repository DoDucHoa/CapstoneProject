using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Helper
{
    public class SearchRequestModel
    {
        public string City { get; set; }
        public string District { get; set; }
        public string StartBooking { get; set; }
        public string EndBooking { get; set; }
        public int Due { get; set; }
        public List<List<PetRequestForSearchCenter>> _petRequests { get; set; }
        public int CustomerId { get; set; }
        public PagingParameter paging { get; set; }
    }
}
