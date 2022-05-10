using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class Customer
    {
        public Customer()
        {
            Bookings = new HashSet<Booking>();
            CustomerAddresses = new HashSet<CustomerAddress>();
            Pets = new HashSet<Pet>();
        }

        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Required]
        [Column("name")]
        [StringLength(256)]
        public string Name { get; set; }
        [Column("birth", TypeName = "date")]
        public DateTime? Birth { get; set; }
        [Column("status")]
        public bool? Status { get; set; }

        [ForeignKey(nameof(Id))]
        [InverseProperty(nameof(Account.Customer))]
        public virtual Account IdNavigation { get; set; }
        [InverseProperty(nameof(Booking.Customer))]
        public virtual ICollection<Booking> Bookings { get; set; }
        [InverseProperty(nameof(CustomerAddress.Customer))]
        public virtual ICollection<CustomerAddress> CustomerAddresses { get; set; }
        [InverseProperty(nameof(Pet.Customer))]
        public virtual ICollection<Pet> Pets { get; set; }
    }
}
