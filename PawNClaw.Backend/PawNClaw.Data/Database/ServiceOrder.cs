using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class ServiceOrder
    {
        [Key]
        [Column("service_code")]
        [StringLength(32)]
        public string ServiceCode { get; set; }
        [Key]
        [Column("booking_id")]
        public int BookingId { get; set; }
        [Column("quantity")]
        public int? Quantity { get; set; }
        [Column("sell_price", TypeName = "numeric(19, 5)")]
        public decimal? SellPrice { get; set; }
        [Column("total_price", TypeName = "numeric(19, 5)")]
        public decimal? TotalPrice { get; set; }

        [ForeignKey(nameof(BookingId))]
        [InverseProperty("ServiceOrders")]
        public virtual Booking Booking { get; set; }
        [ForeignKey(nameof(ServiceCode))]
        [InverseProperty(nameof(Service.ServiceOrders))]
        public virtual Service ServiceCodeNavigation { get; set; }
    }
}
