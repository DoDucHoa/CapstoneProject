using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    [Table("Service")]
    public partial class Service
    {
        public Service()
        {
            ServiceOrders = new HashSet<ServiceOrder>();
        }

        [Key]
        [Column("code")]
        [StringLength(32)]
        public string Code { get; set; }
        [Required]
        [Column("description")]
        [StringLength(512)]
        public string Description { get; set; }
        [Column("sell_price", TypeName = "numeric(19, 5)")]
        public decimal SellPrice { get; set; }
        [Column("discount_price", TypeName = "numeric(19, 5)")]
        public decimal? DiscountPrice { get; set; }
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

        [ForeignKey(nameof(CenterId))]
        [InverseProperty(nameof(PetCenter.Services))]
        public virtual PetCenter Center { get; set; }
        [ForeignKey(nameof(CreateUser))]
        [InverseProperty(nameof(Staff.ServiceCreateUserNavigations))]
        public virtual Staff CreateUserNavigation { get; set; }
        [ForeignKey(nameof(ModifyUser))]
        [InverseProperty(nameof(Staff.ServiceModifyUserNavigations))]
        public virtual Staff ModifyUserNavigation { get; set; }
        [InverseProperty(nameof(ServiceOrder.ServiceCodeNavigation))]
        public virtual ICollection<ServiceOrder> ServiceOrders { get; set; }
    }
}
