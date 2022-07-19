using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class Account
    {
        public Account()
        {
            BrandCreateUserNavigations = new HashSet<Brand>();
            BrandModifyUserNavigations = new HashSet<Brand>();
            CageCreateUserNavigations = new HashSet<Cage>();
            CageModifyUserNavigations = new HashSet<Cage>();
            CageTypeCreateUserNavigations = new HashSet<CageType>();
            CageTypeModifyUserNavigations = new HashSet<CageType>();
            PetCenterCreateUserNavigations = new HashSet<PetCenter>();
            PetCenterModifyUserNavigations = new HashSet<PetCenter>();
            PetTypeCreateUserNavigations = new HashSet<PetType>();
            PetTypeModifyUserNavigations = new HashSet<PetType>();
            PriceCreateUserNavigations = new HashSet<Price>();
            PriceModifyUserNavigations = new HashSet<Price>();
            PriceTypeCreateUserNavigations = new HashSet<PriceType>();
            PriceTypeModifyUserNavigations = new HashSet<PriceType>();
            ServiceCreateUserNavigations = new HashSet<Service>();
            ServiceModifyUserNavigations = new HashSet<Service>();
            ServicePriceCreateUserNavigations = new HashSet<ServicePrice>();
            ServicePriceModifyUserNavigations = new HashSet<ServicePrice>();
            SponsorBannerCreateUserNavigations = new HashSet<SponsorBanner>();
            SponsorBannerModifyUserNavigations = new HashSet<SponsorBanner>();
            StaffCreateUserNavigations = new HashSet<Staff>();
            StaffModifyUserNavigations = new HashSet<Staff>();
            SupplyCreateUserNavigations = new HashSet<Supply>();
            SupplyModifyUserNavigations = new HashSet<Supply>();
            SupplyTypeCreateUserNavigations = new HashSet<SupplyType>();
            SupplyTypeModifyUserNavigations = new HashSet<SupplyType>();
            VoucherCreateUserNavigations = new HashSet<Voucher>();
            VoucherModifyUserNavigations = new HashSet<Voucher>();
            VoucherTypeCreateUserNavigations = new HashSet<VoucherType>();
            VoucherTypeModifyUserNavigations = new HashSet<VoucherType>();
        }

        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Required]
        [Column("user_name")]
        [StringLength(256)]
        public string UserName { get; set; }
        [Column("created_user")]
        public int? CreatedUser { get; set; }
        [Column("device_id")]
        [StringLength(512)]
        public string DeviceId { get; set; }
        [Column("phone")]
        [StringLength(32)]
        public string Phone { get; set; }
        [Column("status")]
        public bool? Status { get; set; }
        [Required]
        [Column("role_code")]
        [StringLength(32)]
        public string RoleCode { get; set; }

        [ForeignKey(nameof(RoleCode))]
        [InverseProperty(nameof(Role.Accounts))]
        public virtual Role RoleCodeNavigation { get; set; }
        [InverseProperty("IdNavigation")]
        public virtual Admin Admin { get; set; }
        [InverseProperty("IdNavigation")]
        public virtual Customer Customer { get; set; }
        [InverseProperty("IdNavigation")]
        public virtual Owner Owner { get; set; }
        [InverseProperty(nameof(Staff.IdNavigation))]
        public virtual Staff StaffIdNavigation { get; set; }
        [InverseProperty(nameof(Brand.CreateUserNavigation))]
        public virtual ICollection<Brand> BrandCreateUserNavigations { get; set; }
        [InverseProperty(nameof(Brand.ModifyUserNavigation))]
        public virtual ICollection<Brand> BrandModifyUserNavigations { get; set; }
        [InverseProperty(nameof(Cage.CreateUserNavigation))]
        public virtual ICollection<Cage> CageCreateUserNavigations { get; set; }
        [InverseProperty(nameof(Cage.ModifyUserNavigation))]
        public virtual ICollection<Cage> CageModifyUserNavigations { get; set; }
        [InverseProperty(nameof(CageType.CreateUserNavigation))]
        public virtual ICollection<CageType> CageTypeCreateUserNavigations { get; set; }
        [InverseProperty(nameof(CageType.ModifyUserNavigation))]
        public virtual ICollection<CageType> CageTypeModifyUserNavigations { get; set; }
        [InverseProperty(nameof(PetCenter.CreateUserNavigation))]
        public virtual ICollection<PetCenter> PetCenterCreateUserNavigations { get; set; }
        [InverseProperty(nameof(PetCenter.ModifyUserNavigation))]
        public virtual ICollection<PetCenter> PetCenterModifyUserNavigations { get; set; }
        [InverseProperty(nameof(PetType.CreateUserNavigation))]
        public virtual ICollection<PetType> PetTypeCreateUserNavigations { get; set; }
        [InverseProperty(nameof(PetType.ModifyUserNavigation))]
        public virtual ICollection<PetType> PetTypeModifyUserNavigations { get; set; }
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
        [InverseProperty(nameof(ServicePrice.CreateUserNavigation))]
        public virtual ICollection<ServicePrice> ServicePriceCreateUserNavigations { get; set; }
        [InverseProperty(nameof(ServicePrice.ModifyUserNavigation))]
        public virtual ICollection<ServicePrice> ServicePriceModifyUserNavigations { get; set; }
        [InverseProperty(nameof(SponsorBanner.CreateUserNavigation))]
        public virtual ICollection<SponsorBanner> SponsorBannerCreateUserNavigations { get; set; }
        [InverseProperty(nameof(SponsorBanner.ModifyUserNavigation))]
        public virtual ICollection<SponsorBanner> SponsorBannerModifyUserNavigations { get; set; }
        [InverseProperty(nameof(Staff.CreateUserNavigation))]
        public virtual ICollection<Staff> StaffCreateUserNavigations { get; set; }
        [InverseProperty(nameof(Staff.ModifyUserNavigation))]
        public virtual ICollection<Staff> StaffModifyUserNavigations { get; set; }
        [InverseProperty(nameof(Supply.CreateUserNavigation))]
        public virtual ICollection<Supply> SupplyCreateUserNavigations { get; set; }
        [InverseProperty(nameof(Supply.ModifyUserNavigation))]
        public virtual ICollection<Supply> SupplyModifyUserNavigations { get; set; }
        [InverseProperty(nameof(SupplyType.CreateUserNavigation))]
        public virtual ICollection<SupplyType> SupplyTypeCreateUserNavigations { get; set; }
        [InverseProperty(nameof(SupplyType.ModifyUserNavigation))]
        public virtual ICollection<SupplyType> SupplyTypeModifyUserNavigations { get; set; }
        [InverseProperty(nameof(Voucher.CreateUserNavigation))]
        public virtual ICollection<Voucher> VoucherCreateUserNavigations { get; set; }
        [InverseProperty(nameof(Voucher.ModifyUserNavigation))]
        public virtual ICollection<Voucher> VoucherModifyUserNavigations { get; set; }
        [InverseProperty(nameof(VoucherType.CreateUserNavigation))]
        public virtual ICollection<VoucherType> VoucherTypeCreateUserNavigations { get; set; }
        [InverseProperty(nameof(VoucherType.ModifyUserNavigation))]
        public virtual ICollection<VoucherType> VoucherTypeModifyUserNavigations { get; set; }

        [NotMapped]
        public ICollection<Photo> Photos { get; set; }
    }
}
