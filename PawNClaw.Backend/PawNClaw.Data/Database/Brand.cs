using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    [Index(nameof(Id), Name = "i")]
    public partial class Brand
    {
        public Brand()
        {
            PetCenters = new HashSet<PetCenter>();
            SponsorBanners = new HashSet<SponsorBanner>();
        }

        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Required]
        [Column("name")]
        [StringLength(256)]
        public string Name { get; set; }
        [Column("description")]
        [StringLength(512)]
        public string Description { get; set; }
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
        [Column("owner_id")]
        public int OwnerId { get; set; }

        [ForeignKey(nameof(CreateUser))]
        [InverseProperty(nameof(Account.BrandCreateUserNavigations))]
        public virtual Account CreateUserNavigation { get; set; }
        [ForeignKey(nameof(ModifyUser))]
        [InverseProperty(nameof(Account.BrandModifyUserNavigations))]
        public virtual Account ModifyUserNavigation { get; set; }
        [ForeignKey(nameof(OwnerId))]
        [InverseProperty("Brands")]
        public virtual Owner Owner { get; set; }
        [InverseProperty(nameof(PetCenter.Brand))]
        public virtual ICollection<PetCenter> PetCenters { get; set; }
        [InverseProperty(nameof(SponsorBanner.Brand))]
        public virtual ICollection<SponsorBanner> SponsorBanners { get; set; }
    }
}
