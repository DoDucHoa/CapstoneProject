using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    [Keyless]
    public partial class PetBookingDetail
    {
        [Column("booking_detail_id")]
        public int BookingDetailId { get; set; }
        [Column("pet_id")]
        public int PetId { get; set; }

        [ForeignKey(nameof(BookingDetailId))]
        public virtual BookingDetail BookingDetail { get; set; }
        [ForeignKey(nameof(PetId))]
        public virtual Pet Pet { get; set; }
    }
}
