using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class BookingActivity
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Column("provide_time", TypeName = "datetime")]
        public DateTime? ProvideTime { get; set; }
        [Column("description")]
        [StringLength(1024)]
        public string Description { get; set; }
        [Column("booking_id")]
        public int BookingId { get; set; }
        [Column("booking_detail_id")]
        public int? BookingDetailId { get; set; }
        [Column("pet_id")]
        public int? PetId { get; set; }
        [Column("supply_id")]
        public int? SupplyId { get; set; }
        [Column("service_id")]
        public int? ServiceId { get; set; }

        [ForeignKey(nameof(BookingId))]
        [InverseProperty("BookingActivities")]
        public virtual Booking Booking { get; set; }
        [ForeignKey(nameof(BookingDetailId))]
        [InverseProperty("BookingActivities")]
        public virtual BookingDetail BookingDetail { get; set; }
        [ForeignKey(nameof(PetId))]
        [InverseProperty("BookingActivities")]
        public virtual Pet Pet { get; set; }
        [ForeignKey(nameof(ServiceId))]
        [InverseProperty("BookingActivities")]
        public virtual Service Service { get; set; }
        [ForeignKey(nameof(SupplyId))]
        [InverseProperty("BookingActivities")]
        public virtual Supply Supply { get; set; }

        [NotMapped]
        public ICollection<Photo> Photos { get; set; }
    }
}
