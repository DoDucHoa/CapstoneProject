using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    class CageParameter
    {
    }

    public class CageRequestParameter
    {
        public string? Code { get; set; }
        public int CenterId { get; set; }
        public bool? IsOnline { get; set; }
        public bool? Status { get; set; } = true;
        public int? CageTypeId { get; set; }

        public string dir { get; set; } = "asc";
        public string sort { get; set; } = null;
        public string fields { get; set; } = null;
        public string includeProperties { get; set; } = null;
    }

    public class ShiftCageParameter
    {
        public List<String> CageCodes { get; set; }
        public int CenterId { get; set; }
    }

    public class CreateCageParameter
    {
        public string Code { get; set; }
        public int CenterId { get; set; }
        public string Name { get; set; }
        public string Color { get; set; }
        public bool IsOnline { get; set; }
        public DateTime? CreateDate { get; set; }
        public DateTime? ModifyDate { get; set; }
        public int? CreateUser { get; set; }
        public int? ModifyUser { get; set; }
        public bool? Status { get; set; }
        public int CageTypeId { get; set; }
    }

    public class UpdateCageParameter
    {
        public string Code { get; set; }

        public int CenterId { get; set; }

        public string Name { get; set; }
        
        public string Color { get; set; }

        public bool IsOnline { get; set; }

        public DateTime? ModifyDate { get; set; }

        public int? ModifyUser { get; set; }

        public bool? Status { get; set; }
    }
}
