using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    [Table("PriceType")]
    public partial class PriceType
    {
        public PriceType()
        {
            Prices = new HashSet<Price>();
        }

        [Key]
        [Column("code")]
        [StringLength(32)]
        public string Code { get; set; }
        [Required]
        [Column("type_name")]
        [StringLength(256)]
        public string TypeName { get; set; }
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
        [InverseProperty(nameof(Staff.PriceTypeCreateUserNavigations))]
        public virtual Staff CreateUserNavigation { get; set; }
        [ForeignKey(nameof(ModifyUser))]
        [InverseProperty(nameof(Staff.PriceTypeModifyUserNavigations))]
        public virtual Staff ModifyUserNavigation { get; set; }
        [InverseProperty(nameof(Price.PriceTypeCodeNavigation))]
        public virtual ICollection<Price> Prices { get; set; }
    }
}
