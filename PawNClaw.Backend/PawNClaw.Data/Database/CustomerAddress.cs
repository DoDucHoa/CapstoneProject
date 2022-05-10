using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class CustomerAddress
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Required]
        [Column("name")]
        [StringLength(512)]
        public string Name { get; set; }
        [Required]
        [Column("address")]
        [StringLength(512)]
        public string Address { get; set; }
        [Column("longtitude")]
        [StringLength(64)]
        public string Longtitude { get; set; }
        [Column("latitude")]
        [StringLength(64)]
        public string Latitude { get; set; }
        [Column("status")]
        public bool? Status { get; set; }
        [Column("customer_id")]
        public int CustomerId { get; set; }

        [ForeignKey(nameof(CustomerId))]
        [InverseProperty("CustomerAddresses")]
        public virtual Customer Customer { get; set; }
    }
}
