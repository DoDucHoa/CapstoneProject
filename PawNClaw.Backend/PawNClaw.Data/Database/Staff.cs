using System;
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
            SupplyCreateUser1s = new HashSet<Supply>();
            SupplyModifyUser1s = new HashSet<Supply>();
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
        [Column("name")]
        [StringLength(256)]
        public string Name { get; set; }

        [ForeignKey(nameof(CenterId))]
        [InverseProperty(nameof(PetCenter.staff))]
        public virtual PetCenter Center { get; set; }
        [ForeignKey(nameof(CreateUser))]
        [InverseProperty(nameof(Account.StaffCreateUserNavigations))]
        public virtual Account CreateUserNavigation { get; set; }
        [ForeignKey(nameof(Id))]
        [InverseProperty(nameof(Account.StaffIdNavigation))]
        public virtual Account IdNavigation { get; set; }
        [ForeignKey(nameof(ModifyUser))]
        [InverseProperty(nameof(Account.StaffModifyUserNavigations))]
        public virtual Account ModifyUserNavigation { get; set; }
        [InverseProperty(nameof(Supply.CreateUser1))]
        public virtual ICollection<Supply> SupplyCreateUser1s { get; set; }
        [InverseProperty(nameof(Supply.ModifyUser1))]
        public virtual ICollection<Supply> SupplyModifyUser1s { get; set; }
        
        [NotMapped]
        public ICollection<Photo> Photos { get; set; }
    }
}
