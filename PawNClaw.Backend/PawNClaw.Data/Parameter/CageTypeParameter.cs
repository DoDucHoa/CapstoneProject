using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    class CageTypeParameter
    {
    }

    public class RequestCageTypeForBookingParameter
    {
        public List<PetRequestForSearchCenter> listPets { get; set; }
        public string StartBooking { get; set; }
        public string EndBooking { get; set; }
        public int CenterId { get; set; }
    }
}
