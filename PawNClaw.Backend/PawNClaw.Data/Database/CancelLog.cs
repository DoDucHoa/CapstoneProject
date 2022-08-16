using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    [Table("CancelLog")]
    public partial class CancelLog
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Column("booking_id")]
        public int BookingId { get; set; }
        [Column("center_id")]
        public int? CenterId { get; set; }
        [Column("customer_id")]
        public int? CustomerId { get; set; }
        [Column("cancel_time", TypeName = "datetime")]
        public DateTime? CancelTime { get; set; }
        [Column("description")]
        [StringLength(256)]
        public string Description { get; set; }

        [ForeignKey(nameof(BookingId))]
        [InverseProperty("CancelLogs")]
        public virtual Booking Booking { get; set; }
        [ForeignKey(nameof(CenterId))]
        [InverseProperty(nameof(PetCenter.CancelLogs))]
        public virtual PetCenter Center { get; set; }
        [ForeignKey(nameof(CustomerId))]
        [InverseProperty("CancelLogs")]
        public virtual Customer Customer { get; set; }
    }
}
