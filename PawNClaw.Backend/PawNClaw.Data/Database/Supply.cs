using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class Supply
    {
        public Supply()
        {
            SupplyOrders = new HashSet<SupplyOrder>();
        }

        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Required]
        [Column("name")]
        [StringLength(256)]
        public string Name { get; set; }
        [Column("sell_price", TypeName = "numeric(19, 5)")]
        public decimal SellPrice { get; set; }
        [Column("discount_price", TypeName = "numeric(19, 5)")]
        public decimal? DiscountPrice { get; set; }
        [Column("quantity")]
        public int Quantity { get; set; }
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
        [Required]
        [Column("supply_type_code")]
        [StringLength(32)]
        public string SupplyTypeCode { get; set; }
        [Column("center_id")]
        public int CenterId { get; set; }

        [ForeignKey(nameof(CenterId))]
        [InverseProperty(nameof(PetCenter.Supplies))]
        public virtual PetCenter Center { get; set; }
        [ForeignKey(nameof(CreateUser))]
        [InverseProperty(nameof(Staff.SupplyCreateUserNavigations))]
        public virtual Staff CreateUserNavigation { get; set; }
        [ForeignKey(nameof(ModifyUser))]
        [InverseProperty(nameof(Staff.SupplyModifyUserNavigations))]
        public virtual Staff ModifyUserNavigation { get; set; }
        [ForeignKey(nameof(SupplyTypeCode))]
        [InverseProperty(nameof(SupplyType.Supplies))]
        public virtual SupplyType SupplyTypeCodeNavigation { get; set; }
        [InverseProperty(nameof(SupplyOrder.Supply))]
        public virtual ICollection<SupplyOrder> SupplyOrders { get; set; }
    }
}
