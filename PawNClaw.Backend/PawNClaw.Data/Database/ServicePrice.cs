using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class ServicePrice
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Column("price", TypeName = "numeric(19, 5)")]
        public decimal Price { get; set; }
        [Column("min_weight", TypeName = "numeric(19, 5)")]
        public decimal? MinWeight { get; set; }
        [Column("max_weight", TypeName = "numeric(19, 5)")]
        public decimal? MaxWeight { get; set; }
        [Column("create_user")]
        public int? CreateUser { get; set; }
        [Column("modify_user")]
        public int? ModifyUser { get; set; }
        [Column("status")]
        public bool? Status { get; set; }
        [Column("service_id")]
        public int ServiceId { get; set; }

        [ForeignKey(nameof(CreateUser))]
        [InverseProperty(nameof(Account.ServicePriceCreateUserNavigations))]
        public virtual Account CreateUserNavigation { get; set; }
        [ForeignKey(nameof(ModifyUser))]
        [InverseProperty(nameof(Account.ServicePriceModifyUserNavigations))]
        public virtual Account ModifyUserNavigation { get; set; }
        [ForeignKey(nameof(ServiceId))]
        [InverseProperty("ServicePrices")]
        public virtual Service Service { get; set; }
    }
}
