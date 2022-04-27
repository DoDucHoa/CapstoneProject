﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    [Table("SupplyType")]
    public partial class SupplyType
    {
        public SupplyType()
        {
            Supplies = new HashSet<Supply>();
        }

        [Key]
        [Column("code")]
        [StringLength(32)]
        public string Code { get; set; }
        [Required]
        [Column("name")]
        [StringLength(256)]
        public string Name { get; set; }
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

        [ForeignKey(nameof(CreateUser))]
        [InverseProperty(nameof(Staff.SupplyTypeCreateUser1s))]
        public virtual Staff CreateUser1 { get; set; }
        [ForeignKey(nameof(CreateUser))]
        [InverseProperty(nameof(Admin.SupplyTypeCreateUserNavigations))]
        public virtual Admin CreateUserNavigation { get; set; }
        [ForeignKey(nameof(ModifyUser))]
        [InverseProperty(nameof(Staff.SupplyTypeModifyUser1s))]
        public virtual Staff ModifyUser1 { get; set; }
        [ForeignKey(nameof(ModifyUser))]
        [InverseProperty(nameof(Admin.SupplyTypeModifyUserNavigations))]
        public virtual Admin ModifyUserNavigation { get; set; }
        [InverseProperty(nameof(Supply.SupplyTypeCodeNavigation))]
        public virtual ICollection<Supply> Supplies { get; set; }
    }
}
