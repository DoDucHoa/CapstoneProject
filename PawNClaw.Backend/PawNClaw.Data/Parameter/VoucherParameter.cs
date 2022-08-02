using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    class VoucherParameter
    {
    }

    public class CreateVoucherParameter
    {
        public string Code { get; set; }
        public decimal? MinCondition { get; set; }
        public decimal? Value { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? ExpireDate { get; set; }
        public DateTime? CreateDate { get; set; }
        public DateTime? ModifyDate { get; set; }
        public int? CreateUser { get; set; }
        public int? ModifyUser { get; set; }
        public bool? Status { get; set; }
        public int CenterId { get; set; }
        public string VoucherTypeCode { get; set; }
        public string Description { get; set; }
    }

    public class UpdateVoucherParameter
    {
        public string Code { get; set; }
        public decimal? MinCondition { get; set; }
        public decimal? Value { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? ExpireDate { get; set; }
        public DateTime? ModifyDate { get; set; }
        public int? ModifyUser { get; set; }
        public bool? Status { get; set; }
        public string Description { get; set; }
    }
}
