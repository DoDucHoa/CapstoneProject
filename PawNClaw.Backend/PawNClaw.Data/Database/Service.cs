﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class Service
    {
        public Service()
        {
            BookingActivities = new HashSet<BookingActivity>();
            ServiceOrders = new HashSet<ServiceOrder>();
            ServicePrices = new HashSet<ServicePrice>();
        }

        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Required]
        [Column("description")]
        [StringLength(512)]
        public string Description { get; set; }
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
        [Column("name")]
        [StringLength(256)]
        public string Name { get; set; }

        [ForeignKey(nameof(CenterId))]
        [InverseProperty(nameof(PetCenter.Services))]
        public virtual PetCenter Center { get; set; }
        [ForeignKey(nameof(CreateUser))]
        [InverseProperty(nameof(Account.ServiceCreateUserNavigations))]
        public virtual Account CreateUserNavigation { get; set; }
        [ForeignKey(nameof(ModifyUser))]
        [InverseProperty(nameof(Account.ServiceModifyUserNavigations))]
        public virtual Account ModifyUserNavigation { get; set; }
        [InverseProperty(nameof(BookingActivity.Service))]
        public virtual ICollection<BookingActivity> BookingActivities { get; set; }
        [InverseProperty(nameof(ServiceOrder.Service))]
        public virtual ICollection<ServiceOrder> ServiceOrders { get; set; }
        [InverseProperty(nameof(ServicePrice.Service))]
        public virtual ICollection<ServicePrice> ServicePrices { get; set; }

        [NotMapped]
        public ICollection<Photo> Photos { get; set; }

        [NotMapped]
        public decimal MinPrice { get; internal set; }

        [NotMapped]
        public decimal MaxPrice { get; internal set; }
    }
}
