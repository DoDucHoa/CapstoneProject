using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class GeneralLedger
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Column("total_money", TypeName = "numeric(19, 5)")]
        public decimal? TotalMoney { get; set; }
        [Column("commision_rate", TypeName = "numeric(19, 5)")]
        public decimal? CommisionRate { get; set; }
        [Column("booking_date", TypeName = "date")]
        public DateTime? BookingDate { get; set; }
        [Column("center_id")]
        public int CenterId { get; set; }

        [ForeignKey(nameof(CenterId))]
        [InverseProperty(nameof(PetCenter.GeneralLedgers))]
        public virtual PetCenter Center { get; set; }
        [ForeignKey(nameof(Id))]
        [InverseProperty(nameof(Booking.GeneralLedger))]
        public virtual Booking IdNavigation { get; set; }
    }
}
