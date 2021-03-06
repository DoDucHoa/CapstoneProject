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

    public class CreateCageTypeParameter
    {
        public string TypeName { get; set; }
        public string Description { get; set; }
        public decimal Height { get; set; }
        public decimal Width { get; set; }
        public decimal Length { get; set; }
        public bool IsSingle { get; set; }
        public DateTime? CreateDate { get; set; }
        public int? CreateUser { get; set; }
        public int CenterId { get; set; }
    }

    public class CreateCageTypeFlowParameter
    {
        public CreateCageTypeParameter createCageTypeParameter { get; set; }

        public List<CreatePriceParameter> createPriceParameters { get; set; }
    }
}
