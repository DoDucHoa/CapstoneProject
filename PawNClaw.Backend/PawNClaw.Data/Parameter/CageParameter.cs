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

        public bool IsOnline { get; set; }

        public DateTime? ModifyDate { get; set; }

        public int? ModifyUser { get; set; }

        public bool? Status { get; set; }
    }
}
