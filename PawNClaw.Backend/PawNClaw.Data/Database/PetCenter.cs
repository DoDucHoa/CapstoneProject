﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    [Index(nameof(Id), Name = "i")]
    public partial class PetCenter
    {
        public PetCenter()
        {
            Bookings = new HashSet<Booking>();
            CageTypes = new HashSet<CageType>();
            Cages = new HashSet<Cage>();
            CancelLogs = new HashSet<CancelLog>();
            CustomerVoucherLogs = new HashSet<CustomerVoucherLog>();
            GeneralLedgers = new HashSet<GeneralLedger>();
            Services = new HashSet<Service>();
            Supplies = new HashSet<Supply>();
            Vouchers = new HashSet<Voucher>();
            staff = new HashSet<Staff>();
        }

        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Required]
        [Column("name")]
        [StringLength(256)]
        public string Name { get; set; }
        [Column("address")]
        [StringLength(256)]
        public string Address { get; set; }
        [Column("phone")]
        [StringLength(32)]
        public string Phone { get; set; }
        [Column("rating", TypeName = "numeric(19, 5)")]
        public decimal? Rating { get; set; }
        [Column("create_date", TypeName = "date")]
        public DateTime? CreateDate { get; set; }
        [Column("modify_date", TypeName = "date")]
        public DateTime? ModifyDate { get; set; }
        [Column("create_user")]
        public int? CreateUser { get; set; }
        [Column("modify_user")]
        public int? ModifyUser { get; set; }
        [Column("status")]
        public bool? Status { get; set; }
        [Column("brand_id")]
        public int BrandId { get; set; }
        [Column("open_time")]
        [StringLength(32)]
        public string OpenTime { get; set; }
        [Column("close_time")]
        [StringLength(32)]
        public string CloseTime { get; set; }
        [Column("description")]
        [StringLength(512)]
        public string Description { get; set; }
        [Column("checkin")]
        [StringLength(256)]
        public string Checkin { get; set; }
        [Column("checkout")]
        [StringLength(256)]
        public string Checkout { get; set; }

        [NotMapped]
        public int RatingCount { get => _getRatingCount(this.Bookings); }

        [NotMapped]
        public DateTime EndBooking { get; set; }

        [NotMapped]
        public DateTime OpenTimeDate { get; set; }

        [NotMapped]
        public DateTime CloseTimeDate { get; set; }

        [NotMapped]
        public DateTime CheckinDate { get; set; }

        [NotMapped]
        public DateTime CheckoutDate { get; set; }

        [ForeignKey(nameof(BrandId))]
        [InverseProperty("PetCenters")]
        public virtual Brand Brand { get; set; }
        [ForeignKey(nameof(CreateUser))]
        [InverseProperty(nameof(Account.PetCenterCreateUserNavigations))]
        public virtual Account CreateUserNavigation { get; set; }
        [ForeignKey(nameof(ModifyUser))]
        [InverseProperty(nameof(Account.PetCenterModifyUserNavigations))]
        public virtual Account ModifyUserNavigation { get; set; }
        [InverseProperty("IdNavigation")]
        public virtual Location Location { get; set; }
        [InverseProperty(nameof(Booking.Center))]
        public virtual ICollection<Booking> Bookings { get; set; }
        [InverseProperty(nameof(CageType.Center))]
        public virtual ICollection<CageType> CageTypes { get; set; }
        [InverseProperty(nameof(Cage.Center))]
        public virtual ICollection<Cage> Cages { get; set; }
        [InverseProperty(nameof(CancelLog.Center))]
        public virtual ICollection<CancelLog> CancelLogs { get; set; }
        [InverseProperty(nameof(CustomerVoucherLog.Center))]
        public virtual ICollection<CustomerVoucherLog> CustomerVoucherLogs { get; set; }
        [InverseProperty(nameof(GeneralLedger.Center))]
        public virtual ICollection<GeneralLedger> GeneralLedgers { get; set; }
        [InverseProperty(nameof(Service.Center))]
        public virtual ICollection<Service> Services { get; set; }
        [InverseProperty(nameof(Supply.Center))]
        public virtual ICollection<Supply> Supplies { get; set; }
        [InverseProperty(nameof(Voucher.Center))]
        public virtual ICollection<Voucher> Vouchers { get; set; }
        [InverseProperty(nameof(Staff.Center))]
        public virtual ICollection<Staff> staff { get; set; }

        [NotMapped]
        public ICollection<Photo> Photos { get; set; }

        [NotMapped]
        public decimal RatingPoint { get => _getRatingPoint(this.Bookings); }

        private int _getRatingCount(ICollection<Booking> Bookings)
        {
            int count = 0;
            foreach (var booking in Bookings)
            {
                if (booking.Rating.HasValue)
                {
                    count++;
                }
            }
            return count;
        }
        private decimal _getRatingPoint(ICollection<Booking> Bookings)
        {
            int count = 0;
            decimal sum = 0;
            foreach (var booking in Bookings)
            {
                if (booking.Rating.HasValue)
                {
                    count++;
                    sum += (int)booking.Rating;
                }
            }
            if (count == 0) return 0;
            return sum / count;
        }
    }
}
