using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class BookingDetail
    {
        public BookingDetail()
        {
            PetBookingDetails = new HashSet<PetBookingDetail>();
        }

        [Key]
        [Column("booking_id")]
        public int BookingId { get; set; }
        [Key]
        [Column("line")]
        public int Line { get; set; }
        [Column("price", TypeName = "numeric(19, 5)")]
        public decimal? Price { get; set; }
        [Required]
        [Column("cage_code")]
        [StringLength(32)]
        public string CageCode { get; set; }
        [Column("center_id")]
        public int CenterId { get; set; }
        [Column("duration", TypeName = "numeric(19, 5)")]
        public decimal? Duration { get; set; }
        [Column("note")]
        [StringLength(512)]
        public string Note { get; set; }

        [ForeignKey(nameof(BookingId))]
        [InverseProperty("BookingDetails")]
        public virtual Booking Booking { get; set; }
        [ForeignKey("CageCode,CenterId")]
        [InverseProperty(nameof(Cage.BookingDetails))]
        public virtual Cage C { get; set; }
        [InverseProperty(nameof(PetBookingDetail.BookingDetail))]
        public virtual ICollection<PetBookingDetail> PetBookingDetails { get; set; }
    }
}
