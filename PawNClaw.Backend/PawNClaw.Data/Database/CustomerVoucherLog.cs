using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    [Table("CustomerVoucherLog")]
    public partial class CustomerVoucherLog
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Column("customer_id")]
        public int CustomerId { get; set; }
        [Column("center_id")]
        public int CenterId { get; set; }
        [Required]
        [Column("voucher_code")]
        [StringLength(32)]
        public string VoucherCode { get; set; }

        [ForeignKey(nameof(CenterId))]
        [InverseProperty(nameof(PetCenter.CustomerVoucherLogs))]
        public virtual PetCenter Center { get; set; }
        [ForeignKey(nameof(CustomerId))]
        [InverseProperty("CustomerVoucherLogs")]
        public virtual Customer Customer { get; set; }
        [ForeignKey(nameof(VoucherCode))]
        [InverseProperty(nameof(Voucher.CustomerVoucherLogs))]
        public virtual Voucher VoucherCodeNavigation { get; set; }
    }
}
