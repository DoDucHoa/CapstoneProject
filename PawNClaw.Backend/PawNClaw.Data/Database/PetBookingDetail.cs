using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class PetBookingDetail
    {
        [Key]
        [Column("booking_detail_id")]
        public int BookingDetailId { get; set; }
        [Key]
        [Column("pet_id")]
        public int PetId { get; set; }

        [ForeignKey(nameof(BookingDetailId))]
        [InverseProperty("PetBookingDetails")]
        public virtual BookingDetail BookingDetail { get; set; }
        [ForeignKey(nameof(PetId))]
        [InverseProperty("PetBookingDetails")]
        public virtual Pet Pet { get; set; }
    }
}
