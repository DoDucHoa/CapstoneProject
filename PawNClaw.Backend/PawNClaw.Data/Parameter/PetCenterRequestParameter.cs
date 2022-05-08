using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
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
}
