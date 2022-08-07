using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class Cage
    {
        public Cage()
        {
            BookingDetails = new HashSet<BookingDetail>();
        }

        [Key]
        [Column("code")]
        [StringLength(32)]
        public string Code { get; set; }
        [Key]
        [Column("center_id")]
        public int CenterId { get; set; }
        [Required]
        [Column("name")]
        [StringLength(256)]
        public string Name { get; set; }
        [Column("color")]
        [StringLength(256)]
        public string Color { get; set; }
        [Column("isOnline")]
        public bool IsOnline { get; set; }
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

        [ForeignKey(nameof(CageTypeId))]
        [InverseProperty("Cages")]
        public virtual CageType CageType { get; set; }
        [ForeignKey(nameof(CenterId))]
        [InverseProperty(nameof(PetCenter.Cages))]
        public virtual PetCenter Center { get; set; }
        [ForeignKey(nameof(CreateUser))]
        [InverseProperty(nameof(Account.CageCreateUserNavigations))]
        public virtual Account CreateUserNavigation { get; set; }
        [ForeignKey(nameof(ModifyUser))]
        [InverseProperty(nameof(Account.CageModifyUserNavigations))]
        public virtual Account ModifyUserNavigation { get; set; }
        [InverseProperty(nameof(BookingDetail.C))]
        public virtual ICollection<BookingDetail> BookingDetails { get; set; }

        [NotMapped]
        public bool CanShift { get; set; }
    }
}
