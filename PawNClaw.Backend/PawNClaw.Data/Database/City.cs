using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    [Table("City")]
    public partial class City
    {
        public City()
        {
            Districts = new HashSet<District>();
            Locations = new HashSet<Location>();
            Wards = new HashSet<Ward>();
        }

        [Key]
        [Column("code")]
        [StringLength(32)]
        public string Code { get; set; }
        [Required]
        [Column("name")]
        [StringLength(256)]
        public string Name { get; set; }

        [InverseProperty(nameof(District.CityCodeNavigation))]
        public virtual ICollection<District> Districts { get; set; }
        [InverseProperty(nameof(Location.CityCodeNavigation))]
        public virtual ICollection<Location> Locations { get; set; }
        [InverseProperty(nameof(Ward.CityCodeNavigation))]
        public virtual ICollection<Ward> Wards { get; set; }
    }
}
