using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class Role
    {
        public Role()
        {
            Accounts = new HashSet<Account>();
        }

        [Key]
        [Column("code")]
        [StringLength(32)]
        public string Code { get; set; }
        [Required]
        [Column("role_name")]
        [StringLength(256)]
        public string RoleName { get; set; }
        [Column("status")]
        public bool? Status { get; set; }

        [InverseProperty(nameof(Account.RoleCodeNavigation))]
        public virtual ICollection<Account> Accounts { get; set; }
    }
}
