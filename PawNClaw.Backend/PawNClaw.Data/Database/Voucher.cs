using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class Voucher
    {
        public Voucher()
        {
            Bookings = new HashSet<Booking>();
        }

        [Key]
        [Column("code")]
        [StringLength(32)]
        public string Code { get; set; }
        [Column("min_condition", TypeName = "numeric(19, 5)")]
        public decimal? MinCondition { get; set; }
        [Column("value", TypeName = "numeric(19, 5)")]
        public decimal? Value { get; set; }
        [Column("start_date", TypeName = "date")]
        public DateTime? StartDate { get; set; }
        [Column("expire_date", TypeName = "date")]
        public DateTime? ExpireDate { get; set; }
        [Column("create_date", TypeName = "date")]
        public DateTime? CreateDate { get; set; }
        [Column("modify_date", TypeName = "date")]
        public DateTime? ModifyDate { get; set; }
        [Column("create_user")]
        public int? CreateUser { get; set; }
        [Column("modify_user")]
        public int? ModifyUser { get; set; }
        [Column("status")]
        public bool? Status { get; set; }
        [Column("center_id")]
        public int CenterId { get; set; }
        [Required]
        [Column("voucher_type_code")]
        [StringLength(32)]
        public string VoucherTypeCode { get; set; }

        [ForeignKey(nameof(CenterId))]
        [InverseProperty(nameof(PetCenter.Vouchers))]
        public virtual PetCenter Center { get; set; }
        [ForeignKey(nameof(CreateUser))]
        [InverseProperty(nameof(Account.VoucherCreateUserNavigations))]
        public virtual Account CreateUserNavigation { get; set; }
        [ForeignKey(nameof(ModifyUser))]
        [InverseProperty(nameof(Account.VoucherModifyUserNavigations))]
        public virtual Account ModifyUserNavigation { get; set; }
        [ForeignKey(nameof(VoucherTypeCode))]
        [InverseProperty(nameof(VoucherType.Vouchers))]
        public virtual VoucherType VoucherTypeCodeNavigation { get; set; }
        [InverseProperty(nameof(Booking.VoucherCodeNavigation))]
        public virtual ICollection<Booking> Bookings { get; set; }

        [NotMapped]
        public string VoucherTypeName { get; internal set; }
    }
}
