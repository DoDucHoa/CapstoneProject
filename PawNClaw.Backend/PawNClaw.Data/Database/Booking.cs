using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class Booking
    {
        public Booking()
        {
            BookingActivities = new HashSet<BookingActivity>();
            BookingDetails = new HashSet<BookingDetail>();
            CancelLogs = new HashSet<CancelLog>();
            PetHealthHistories = new HashSet<PetHealthHistory>();
            ServiceOrders = new HashSet<ServiceOrder>();
            SupplyOrders = new HashSet<SupplyOrder>();
        }

        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Column("sub_total", TypeName = "numeric(19, 5)")]
        public decimal? SubTotal { get; set; }
        [Column("discount", TypeName = "numeric(19, 5)")]
        public decimal? Discount { get; set; }
        [Column("total", TypeName = "numeric(19, 5)")]
        public decimal? Total { get; set; }
        [Column("check_in", TypeName = "datetime")]
        public DateTime? CheckIn { get; set; }
        [Column("check_out", TypeName = "datetime")]
        public DateTime? CheckOut { get; set; }
        [Column("create_time", TypeName = "datetime")]
        public DateTime? CreateTime { get; set; }
        [Column("start_booking", TypeName = "datetime")]
        public DateTime? StartBooking { get; set; }
        [Column("end_booking", TypeName = "datetime")]
        public DateTime? EndBooking { get; set; }
        [Column("status_id")]
        public int StatusId { get; set; }
        [Column("voucher_code")]
        [StringLength(32)]
        public string VoucherCode { get; set; }
        [Column("customer_id")]
        public int CustomerId { get; set; }
        [Column("center_id")]
        public int CenterId { get; set; }
        [Column("rating")]
        public byte? Rating { get; set; }
        [Column("customer_note")]
        [StringLength(512)]
        public string CustomerNote { get; set; }
        [Column("staff_note")]
        [StringLength(512)]
        public string StaffNote { get; set; }
        [Column("invoice_url")]
        [StringLength(1024)]
        public string InvoiceUrl { get; set; }
        [Column("feedback")]
        [StringLength(1024)]
        public string Feedback { get; set; }

        [NotMapped]
        public decimal? TotalSupply { get; set; }
        [NotMapped]
        public decimal? TotalService { get; set; }
        [NotMapped]
        public decimal? TotalCage { get; set; }

        [ForeignKey(nameof(CenterId))]
        [InverseProperty(nameof(PetCenter.Bookings))]
        public virtual PetCenter Center { get; set; }
        [ForeignKey(nameof(CustomerId))]
        [InverseProperty("Bookings")]
        public virtual Customer Customer { get; set; }
        [ForeignKey(nameof(StatusId))]
        [InverseProperty(nameof(BookingStatus.Bookings))]
        public virtual BookingStatus Status { get; set; }
        [ForeignKey(nameof(VoucherCode))]
        [InverseProperty(nameof(Voucher.Bookings))]
        public virtual Voucher VoucherCodeNavigation { get; set; }
        [InverseProperty("IdNavigation")]
        public virtual GeneralLedger GeneralLedger { get; set; }
        [InverseProperty(nameof(BookingActivity.Booking))]
        public virtual ICollection<BookingActivity> BookingActivities { get; set; }
        [InverseProperty(nameof(BookingDetail.Booking))]
        public virtual ICollection<BookingDetail> BookingDetails { get; set; }
        [InverseProperty(nameof(CancelLog.Booking))]
        public virtual ICollection<CancelLog> CancelLogs { get; set; }
        [InverseProperty(nameof(PetHealthHistory.Booking))]
        public virtual ICollection<PetHealthHistory> PetHealthHistories { get; set; }
        [InverseProperty(nameof(ServiceOrder.Booking))]
        public virtual ICollection<ServiceOrder> ServiceOrders { get; set; }
        [InverseProperty(nameof(SupplyOrder.Booking))]
        public virtual ICollection<SupplyOrder> SupplyOrders { get; set; }

        [NotMapped]
        public ICollection<Photo> Photos { get; set; }
    }
}
