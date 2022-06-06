using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class Owner
    {
        public Owner()
        {
            Brands = new HashSet<Brand>();
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
        [Required]
        [Column("email")]
        [StringLength(256)]
        public string Email { get; set; }
        [Column("gender")]
        public int? Gender { get; set; }

        [ForeignKey(nameof(Id))]
        [InverseProperty(nameof(Account.Owner))]
        public virtual Account IdNavigation { get; set; }
        [InverseProperty(nameof(Brand.Owner))]
        public virtual ICollection<Brand> Brands { get; set; }
        [InverseProperty(nameof(Staff.CreateUserNavigation))]
        public virtual ICollection<Staff> StaffCreateUserNavigations { get; set; }
        [InverseProperty(nameof(Staff.ModifyUserNavigation))]
        public virtual ICollection<Staff> StaffModifyUserNavigations { get; set; }
    }
}
