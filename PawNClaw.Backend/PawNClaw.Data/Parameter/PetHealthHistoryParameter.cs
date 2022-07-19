using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    class PetHealthHistoryParameter
    {
    }

    public class CreatePetHealthHistoryParameter
    {
        public DateTime CheckedDate { get; set; }
        public string Description { get; set; }
        public string CenterName { get; set; }
        public int PetId { get; set; }
        public decimal Length { get; set; }
        public decimal Height { get; set; }
        public decimal Weight { get; set; }
        public int BookingId { get; set; }
    }

    public class CreateUpdatePetHealthHistoryParameter
    {
        public bool IsUpdatePet { get; set; }
        public CreatePetHealthHistoryParameter createPetHealthHistoryParameter { get; set; }
    }
}
