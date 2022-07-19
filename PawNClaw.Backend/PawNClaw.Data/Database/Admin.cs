using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class Admin
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Required]
        [Column("name")]
        [StringLength(256)]
        public string Name { get; set; }
        [Column("email")]
        [StringLength(256)]
        public string Email { get; set; }
        [Column("gender")]
        public int? Gender { get; set; }

        [ForeignKey(nameof(Id))]
        [InverseProperty(nameof(Account.Admin))]
        public virtual Account IdNavigation { get; set; }
    }
}
