using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class PetHealthHistory
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Column("checked_date", TypeName = "date")]
        public DateTime CheckedDate { get; set; }
        [Required]
        [Column("description")]
        [StringLength(512)]
        public string Description { get; set; }
        [Required]
        [Column("center_name")]
        [StringLength(256)]
        public string CenterName { get; set; }
        [Column("pet_id")]
        public int PetId { get; set; }

        [ForeignKey(nameof(PetId))]
        [InverseProperty("PetHealthHistories")]
        public virtual Pet Pet { get; set; }
    }
}
