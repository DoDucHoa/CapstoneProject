using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    [Table("Admin")]
    public partial class Admin
    {
        public Admin()
        {
            BrandCreateUserNavigations = new HashSet<Brand>();
            BrandModifyUserNavigations = new HashSet<Brand>();
            PetCenterCreateUserNavigations = new HashSet<PetCenter>();
            PetCenterModifyUserNavigations = new HashSet<PetCenter>();
            PetTypeCreateUserNavigations = new HashSet<PetType>();
            PetTypeModifyUserNavigations = new HashSet<PetType>();
            SponsorBannerCreateUserNavigations = new HashSet<SponsorBanner>();
            SponsorBannerModifyUserNavigations = new HashSet<SponsorBanner>();
            StaffCreateUserNavigations = new HashSet<Staff>();
            StaffModifyUserNavigations = new HashSet<Staff>();
        }

        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Required]
        [Column("name")]
        [StringLength(256)]
        public string Name { get; set; }
        [Column("email")]
        [StringLength(256)]
        public string Email { get; set; }
        [Column("phone")]
        [StringLength(32)]
        public string Phone { get; set; }
        [Column("status")]
        public bool? Status { get; set; }

        [ForeignKey(nameof(Id))]
        [InverseProperty(nameof(Account.Admin))]
        public virtual Account IdNavigation { get; set; }
        [InverseProperty(nameof(Brand.CreateUserNavigation))]
        public virtual ICollection<Brand> BrandCreateUserNavigations { get; set; }
        [InverseProperty(nameof(Brand.ModifyUserNavigation))]
        public virtual ICollection<Brand> BrandModifyUserNavigations { get; set; }
        [InverseProperty(nameof(PetCenter.CreateUserNavigation))]
        public virtual ICollection<PetCenter> PetCenterCreateUserNavigations { get; set; }
        [InverseProperty(nameof(PetCenter.ModifyUserNavigation))]
        public virtual ICollection<PetCenter> PetCenterModifyUserNavigations { get; set; }
        [InverseProperty(nameof(PetType.CreateUserNavigation))]
        public virtual ICollection<PetType> PetTypeCreateUserNavigations { get; set; }
        [InverseProperty(nameof(PetType.ModifyUserNavigation))]
        public virtual ICollection<PetType> PetTypeModifyUserNavigations { get; set; }
        [InverseProperty(nameof(SponsorBanner.CreateUserNavigation))]
        public virtual ICollection<SponsorBanner> SponsorBannerCreateUserNavigations { get; set; }
        [InverseProperty(nameof(SponsorBanner.ModifyUserNavigation))]
        public virtual ICollection<SponsorBanner> SponsorBannerModifyUserNavigations { get; set; }
        [InverseProperty(nameof(Staff.CreateUserNavigation))]
        public virtual ICollection<Staff> StaffCreateUserNavigations { get; set; }
        [InverseProperty(nameof(Staff.ModifyUserNavigation))]
        public virtual ICollection<Staff> StaffModifyUserNavigations { get; set; }
    }
}
