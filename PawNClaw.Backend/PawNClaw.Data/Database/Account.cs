using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    [Table("Account")]
    public partial class Account
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Required]
        [Column("user_name")]
        [StringLength(256)]
        public string UserName { get; set; }
        [Column("created_user")]
        public int? CreatedUser { get; set; }
        [Column("status")]
        public bool? Status { get; set; }
        [Required]
        [Column("role_code")]
        [StringLength(32)]
        public string RoleCode { get; set; }
        [Column("device_id")]
        [StringLength(512)]
        public string DeviceId { get; set; }
        [Column("phone")]
        [StringLength(32)]
        public string Phone { get; set; }

        [ForeignKey(nameof(RoleCode))]
        [InverseProperty(nameof(Role.Accounts))]
        public virtual Role RoleCodeNavigation { get; set; }
        [InverseProperty("IdNavigation")]
        public virtual Admin Admin { get; set; }
        [InverseProperty("IdNavigation")]
        public virtual Customer Customer { get; set; }
        [InverseProperty("IdNavigation")]
        public virtual Owner Owner { get; set; }
        [InverseProperty("IdNavigation")]
        public virtual Staff Staff { get; set; }
    }
}
