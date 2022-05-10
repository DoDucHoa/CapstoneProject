﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class Staff
    {
        public Staff()
        {
            CageCreateUserNavigations = new HashSet<Cage>();
            CageModifyUserNavigations = new HashSet<Cage>();
            CageTypeCreateUserNavigations = new HashSet<CageType>();
            CageTypeModifyUserNavigations = new HashSet<CageType>();
            PriceCreateUserNavigations = new HashSet<Price>();
            PriceModifyUserNavigations = new HashSet<Price>();
            PriceTypeCreateUserNavigations = new HashSet<PriceType>();
            PriceTypeModifyUserNavigations = new HashSet<PriceType>();
            ServiceCreateUserNavigations = new HashSet<Service>();
            ServiceModifyUserNavigations = new HashSet<Service>();
            SupplyCreateUserNavigations = new HashSet<Supply>();
            SupplyModifyUserNavigations = new HashSet<Supply>();
            VoucherCreateUserNavigations = new HashSet<Voucher>();
            VoucherModifyUserNavigations = new HashSet<Voucher>();
        }

        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Column("center_id")]
        public int CenterId { get; set; }
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

        [ForeignKey(nameof(CenterId))]
        [InverseProperty(nameof(PetCenter.Staff))]
        public virtual PetCenter Center { get; set; }
        [ForeignKey(nameof(CreateUser))]
        [InverseProperty(nameof(Admin.StaffCreateUserNavigations))]
        public virtual Admin CreateUserNavigation { get; set; }
        [ForeignKey(nameof(Id))]
        [InverseProperty(nameof(Account.Staff))]
        public virtual Account IdNavigation { get; set; }
        [ForeignKey(nameof(ModifyUser))]
        [InverseProperty(nameof(Admin.StaffModifyUserNavigations))]
        public virtual Admin ModifyUserNavigation { get; set; }
        [InverseProperty(nameof(Cage.CreateUserNavigation))]
        public virtual ICollection<Cage> CageCreateUserNavigations { get; set; }
        [InverseProperty(nameof(Cage.ModifyUserNavigation))]
        public virtual ICollection<Cage> CageModifyUserNavigations { get; set; }
        [InverseProperty(nameof(CageType.CreateUserNavigation))]
        public virtual ICollection<CageType> CageTypeCreateUserNavigations { get; set; }
        [InverseProperty(nameof(CageType.ModifyUserNavigation))]
        public virtual ICollection<CageType> CageTypeModifyUserNavigations { get; set; }
        [InverseProperty(nameof(Price.CreateUserNavigation))]
        public virtual ICollection<Price> PriceCreateUserNavigations { get; set; }
        [InverseProperty(nameof(Price.ModifyUserNavigation))]
        public virtual ICollection<Price> PriceModifyUserNavigations { get; set; }
        [InverseProperty(nameof(PriceType.CreateUserNavigation))]
        public virtual ICollection<PriceType> PriceTypeCreateUserNavigations { get; set; }
        [InverseProperty(nameof(PriceType.ModifyUserNavigation))]
        public virtual ICollection<PriceType> PriceTypeModifyUserNavigations { get; set; }
        [InverseProperty(nameof(Service.CreateUserNavigation))]
        public virtual ICollection<Service> ServiceCreateUserNavigations { get; set; }
        [InverseProperty(nameof(Service.ModifyUserNavigation))]
        public virtual ICollection<Service> ServiceModifyUserNavigations { get; set; }
        [InverseProperty(nameof(Supply.CreateUserNavigation))]
        public virtual ICollection<Supply> SupplyCreateUserNavigations { get; set; }
        [InverseProperty(nameof(Supply.ModifyUserNavigation))]
        public virtual ICollection<Supply> SupplyModifyUserNavigations { get; set; }
        [InverseProperty(nameof(Voucher.CreateUserNavigation))]
        public virtual ICollection<Voucher> VoucherCreateUserNavigations { get; set; }
        [InverseProperty(nameof(Voucher.ModifyUserNavigation))]
        public virtual ICollection<Voucher> VoucherModifyUserNavigations { get; set; }
    }
}
