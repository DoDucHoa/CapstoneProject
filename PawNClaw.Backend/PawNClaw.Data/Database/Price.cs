using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class Price
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Column("unit_price", TypeName = "numeric(19, 5)")]
        public decimal UnitPrice { get; set; }
        [Column("date_from", TypeName = "date")]
        public DateTime? DateFrom { get; set; }
        [Column("date_to", TypeName = "date")]
        public DateTime? DateTo { get; set; }
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
        [Column("cage_type_id")]
        public int CageTypeId { get; set; }
        [Required]
        [Column("price_type_code")]
        [StringLength(32)]
        public string PriceTypeCode { get; set; }

        [ForeignKey(nameof(CageTypeId))]
        [InverseProperty("Prices")]
        public virtual CageType CageType { get; set; }
        [ForeignKey(nameof(CreateUser))]
        [InverseProperty(nameof(Staff.PriceCreateUserNavigations))]
        public virtual Staff CreateUserNavigation { get; set; }
        [ForeignKey(nameof(ModifyUser))]
        [InverseProperty(nameof(Staff.PriceModifyUserNavigations))]
        public virtual Staff ModifyUserNavigation { get; set; }
        [ForeignKey(nameof(PriceTypeCode))]
        [InverseProperty(nameof(PriceType.Prices))]
        public virtual PriceType PriceTypeCodeNavigation { get; set; }
    }
}
