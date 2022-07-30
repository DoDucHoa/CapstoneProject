using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    public class UpdatePetCenterForOwnerParam
    {
        public int Id { get; set; }
        public int? ModifyUser { get; set; }
        public string OpenTime { get; set; } = null;
        public string CloseTime { get; set; } = null;
        public string CheckIn { get; set; } = null;
        public string CheckOut { get; set; } = null;
        public string Description { get; set; } = null;
        public string Phone { get; set; } = null;
    }

    public class UpdatePetCenterForAdminParam
    {
        public int Id { get; set; }
        public int ModifyUser { get; set; }
        public string OpenTime { get; set; } = null;
        public string CloseTime { get; set; } = null;
        public string CheckIn { get; set; } = null;
        public string CheckOut { get; set; } = null;
        public string Description { get; set; } = null;
        public string Phone { get; set; } = null;
        public string Address { get; set; } = null;
        public bool Status { get; set; }
    }

    public class PetCenterRequestParameter
    {
        public int? Id { get; set; } = null;
        public string Name { get; set; } = null;
        public string Address { get; set; } = null;
        public string Phone { get; set; } = null;
        public int? Rating { get; set; } = null;
        public DateTime? CreateDate { get; set; } = null;
        public DateTime? ModifyDate { get; set; } = null;
        public int? CreateUser { get; set; } = null;
        public int? ModifyUser { get; set; } = null;
        public bool? Status { get; set; } = null;
        public int? BrandId { get; set; } = null;
        public string OpenTime { get; set; } = null;
        public string CloseTime { get; set; } = null;

        public string dir { get; set; } = "asc";
        public string sort { get; set; } = null;
        public string fields { get; set; } = null;
        public string includeProperties { get; set; } = null;
    }

    public class SearchPetCenterResponse
    {
        public PagedList<PetCenter> petCenters { get; set; }
        public string City { get; set; }
        public string District { get; set; }
        public string DistrictName { get; set; }
    }
}
