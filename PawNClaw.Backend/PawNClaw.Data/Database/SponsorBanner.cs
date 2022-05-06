using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class SponsorBanner
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Required]
        [Column("title")]
        [StringLength(256)]
        public string Title { get; set; }
        [Required]
        [Column("content")]
        [StringLength(1024)]
        public string Content { get; set; }
        [Column("start_date", TypeName = "date")]
        public DateTime? StartDate { get; set; }
        [Column("end_date", TypeName = "date")]
        public DateTime? EndDate { get; set; }
        [Column("duration", TypeName = "numeric(19, 5)")]
        public decimal? Duration { get; set; }
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
        [Column("brand_id")]
        public int BrandId { get; set; }

        [ForeignKey(nameof(BrandId))]
        [InverseProperty("SponsorBanners")]
        public virtual Brand Brand { get; set; }
        [ForeignKey(nameof(CreateUser))]
        [InverseProperty(nameof(Admin.SponsorBannerCreateUserNavigations))]
        public virtual Admin CreateUserNavigation { get; set; }
        [ForeignKey(nameof(ModifyUser))]
        [InverseProperty(nameof(Admin.SponsorBannerModifyUserNavigations))]
        public virtual Admin ModifyUserNavigation { get; set; }
    }
}
