using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class PetType
    {
        public PetType()
        {
            Pets = new HashSet<Pet>();
        }

        [Key]
        [Column("code")]
        [StringLength(32)]
        public string Code { get; set; }
        [Required]
        [Column("name")]
        [StringLength(256)]
        public string Name { get; set; }
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

        [ForeignKey(nameof(CreateUser))]
        [InverseProperty(nameof(Admin.PetTypeCreateUserNavigations))]
        public virtual Admin CreateUserNavigation { get; set; }
        [ForeignKey(nameof(ModifyUser))]
        [InverseProperty(nameof(Admin.PetTypeModifyUserNavigations))]
        public virtual Admin ModifyUserNavigation { get; set; }
        [InverseProperty(nameof(Pet.PetTypeCodeNavigation))]
        public virtual ICollection<Pet> Pets { get; set; }
    }
}
