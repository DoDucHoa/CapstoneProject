using PawNClaw.Data.Database;
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

    public class CageTypeRequestParameter
    {
        public string? TypeName { get; set; }
        public int? id { get; set; }
        public int CenterId { get; set; }
        public bool? IsSingle { get; set; }
        public bool? Status { get; set; }
        public string dir { get; set; } = "asc";
        public string sort { get; set; } = null;
        public string fields { get; set; } = null;
        public string includeProperties { get; set; } = null;
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
        public DateTime? ModifyDate { get; set; }
        public int? CreateUser { get; set; }
        public int? ModifyUser { get; set; }
        public bool? Status { get; set; }
        public int CenterId { get; set; }
    }

    public class UpdateCageTypeParameter
    {
        public int Id { get; set; }
        public string TypeName { get; set; }
        public string Description { get; set; }
        public bool IsSingle { get; set; }
        public DateTime? ModifyDate { get; set; }
        public int? ModifyUser { get; set; }
        public bool? Status { get; set; }
    }

    public class CreateCageTypeFlowParameter
    {
        public CreateCageTypeParameter createCageTypeParameter { get; set; }

        public List<CreatePriceParameter> createPriceParameters { get; set; }

        public List<CreateFoodSchedule> foodSchedules { get; set; }
    }

    public class UpdateCageTypeFlowParameter
    {
        public UpdateCageTypeParameter updateCageTypeParameter { get; set; }
        public List<UpdatePriceParameter> updatePriceParameters { get; set; }
        public List<UpdateFoodSchedule> updateFoodSchedules { get; set; }
    }
}
