using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    public class PetRequestParameter
    {
        public int? Id { get; set; } = null;
        public decimal? Weight { get; set; } = null;
        public decimal? Length { get; set; } = null;
        public decimal? Height { get; set; } = null;
        public string Name { get; set; } = null;
        public DateTime? Birth { get; set; } = null;
        public bool? Status { get; set; } = null;
        public int? CustomerId { get; set; } = null;
        public string PetTypeCode { get; set; } = null;

        public string dir { get; set; } = "asc";
        public string sort { get; set; } = null;
        public string fields { get; set; } = null;
        public string includeProperties { get; set; } = null;
    }

    public class UpdatePetRequestParameter
    {
        public int Id { get; set; }
        public decimal Weight { get; set; }
        public decimal Length { get; set; }
        public decimal Height { get; set; }
    }

    public class UpdatePetRequestForCusParameter
    {
        public int Id { get; set; }
        public decimal Weight { get; set; }
        public decimal Length { get; set; }
        public decimal Height { get; set; }
        public string Name { get; set; }
        public DateTime? Birth { get; set; }
    }

    public class CreatePetRequestParameter
    {
        public decimal Weight { get; set; }
        public decimal Length { get; set; }
        public decimal Height { get; set; }
        public string Name { get; set; }
        public DateTime? Birth { get; set; }
        public bool Status { get; set; }
        public int CustomerId { get; set; }
        public string PetTypeCode { get; set; }
        public string BreedName { get; set; }
        public String photoUrl { get; set; }
    }

    public class PetRequestForSearchCenter
    {
        public int Id { get; set; }
        public decimal Weight { get; set; }
        public decimal Length { get; set; }
        public decimal Height { get; set; }
    }
}
