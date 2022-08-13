using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    [Index(nameof(Id), Name = "i")]
    public partial class CageType
    {
        public CageType()
        {
            Cages = new HashSet<Cage>();
            FoodSchedules = new HashSet<FoodSchedule>();
            Prices = new HashSet<Price>();
        }

        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Required]
        [Column("type_name")]
        [StringLength(256)]
        public string TypeName { get; set; }
        [Column("description")]
        [StringLength(512)]
        public string Description { get; set; }
        [Column("height", TypeName = "numeric(19, 5)")]
        public decimal Height { get; set; }
        [Column("width", TypeName = "numeric(19, 5)")]
        public decimal Width { get; set; }
        [Column("length", TypeName = "numeric(19, 5)")]
        public decimal Length { get; set; }
        [Column("is_single")]
        public bool IsSingle { get; set; }
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

        [NotMapped]
        public string TotalPrice { get; set; }

        [NotMapped]
        public bool? CanDelete { get; set; }

        [ForeignKey(nameof(CenterId))]
        [InverseProperty(nameof(PetCenter.CageTypes))]
        public virtual PetCenter Center { get; set; }
        [ForeignKey(nameof(CreateUser))]
        [InverseProperty(nameof(Account.CageTypeCreateUserNavigations))]
        public virtual Account CreateUserNavigation { get; set; }
        [ForeignKey(nameof(ModifyUser))]
        [InverseProperty(nameof(Account.CageTypeModifyUserNavigations))]
        public virtual Account ModifyUserNavigation { get; set; }
        [InverseProperty(nameof(Cage.CageType))]
        public virtual ICollection<Cage> Cages { get; set; }
        [InverseProperty(nameof(FoodSchedule.CageType))]
        public virtual ICollection<FoodSchedule> FoodSchedules { get; set; }
        [InverseProperty(nameof(Price.CageType))]
        public virtual ICollection<Price> Prices { get; set; }

        [NotMapped]
        public ICollection<Photo> Photos { get; set; }

        [NotMapped]
        public decimal MaxPrice { get; internal set; }

        [NotMapped]
        public decimal MinPrice { get; internal set; }
    }
}
