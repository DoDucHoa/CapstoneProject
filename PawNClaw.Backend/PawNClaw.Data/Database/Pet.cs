using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class Pet
    {
        public Pet()
        {
            BookingActivities = new HashSet<BookingActivity>();
            PetBookingDetails = new HashSet<PetBookingDetail>();
            PetHealthHistories = new HashSet<PetHealthHistory>();
            ServiceOrders = new HashSet<ServiceOrder>();
            SupplyOrders = new HashSet<SupplyOrder>();
        }

        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Column("weight", TypeName = "numeric(19, 5)")]
        public decimal Weight { get; set; }
        [Column("length", TypeName = "numeric(19, 5)")]
        public decimal Length { get; set; }
        [Column("height", TypeName = "numeric(19, 5)")]
        public decimal Height { get; set; }
        [Required]
        [Column("name")]
        [StringLength(256)]
        public string Name { get; set; }
        [Column("birth", TypeName = "date")]
        public DateTime? Birth { get; set; }
        [Column("status")]
        public bool? Status { get; set; }
        [Column("customer_id")]
        public int CustomerId { get; set; }
        [Required]
        [Column("pet_type_code")]
        [StringLength(32)]
        public string PetTypeCode { get; set; }
        [Column("breed_name")]
        [StringLength(256)]
        public string BreedName { get; set; }

        [ForeignKey(nameof(CustomerId))]
        [InverseProperty("Pets")]
        public virtual Customer Customer { get; set; }
        [ForeignKey(nameof(PetTypeCode))]
        [InverseProperty(nameof(PetType.Pets))]
        public virtual PetType PetTypeCodeNavigation { get; set; }
        [InverseProperty(nameof(BookingActivity.Pet))]
        public virtual ICollection<BookingActivity> BookingActivities { get; set; }
        [InverseProperty(nameof(PetBookingDetail.Pet))]
        public virtual ICollection<PetBookingDetail> PetBookingDetails { get; set; }
        [InverseProperty(nameof(PetHealthHistory.Pet))]
        public virtual ICollection<PetHealthHistory> PetHealthHistories { get; set; }
        [InverseProperty(nameof(ServiceOrder.Pet))]
        public virtual ICollection<ServiceOrder> ServiceOrders { get; set; }
        [InverseProperty(nameof(SupplyOrder.Pet))]
        public virtual ICollection<SupplyOrder> SupplyOrders { get; set; }

        [NotMapped]
        public ICollection<Photo> Photos { get; set; }
    }
}
