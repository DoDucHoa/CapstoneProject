﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    [Table("Owner")]
    public partial class Owner
    {
        public Owner()
        {
            Brands = new HashSet<Brand>();
        }

        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Required]
        [Column("name")]
        [StringLength(256)]
        public string Name { get; set; }
        [Required]
        [Column("email")]
        [StringLength(256)]
        public string Email { get; set; }
        [Column("phone")]
        [StringLength(32)]
        public string Phone { get; set; }
        [Column("status")]
        public bool? Status { get; set; }

        [ForeignKey(nameof(Id))]
        [InverseProperty(nameof(Account.Owner))]
        public virtual Account IdNavigation { get; set; }
        [InverseProperty(nameof(Brand.Owner))]
        public virtual ICollection<Brand> Brands { get; set; }
    }
}
