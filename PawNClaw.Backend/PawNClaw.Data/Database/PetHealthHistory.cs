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
        [Column("weight", TypeName = "numeric(19, 5)")]
        public decimal? Weight { get; set; }
        [Column("height", TypeName = "numeric(19, 5)")]
        public decimal? Height { get; set; }
        [Column("length", TypeName = "numeric(19, 5)")]
        public decimal? Length { get; set; }
        [Column("pet_id")]
        public int PetId { get; set; }
        [Column("booking_id")]
        public int BookingId { get; set; }

        [ForeignKey(nameof(BookingId))]
        [InverseProperty("PetHealthHistories")]
        public virtual Booking Booking { get; set; }
        [ForeignKey(nameof(PetId))]
        [InverseProperty("PetHealthHistories")]
        public virtual Pet Pet { get; set; }
    }
}
