using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    [Table("District")]
    public partial class District
    {
        public District()
        {
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
        [Required]
        [Column("city_code")]
        [StringLength(32)]
        public string CityCode { get; set; }
        [Column("latitude")]
        [StringLength(64)]
        public string Latitude { get; set; }
        [Column("longtitude")]
        [StringLength(64)]
        public string Longtitude { get; set; }

        [ForeignKey(nameof(CityCode))]
        [InverseProperty(nameof(City.Districts))]
        public virtual City CityCodeNavigation { get; set; }
        [InverseProperty(nameof(Location.DistrictCodeNavigation))]
        public virtual ICollection<Location> Locations { get; set; }
        [InverseProperty(nameof(Ward.DistrictCodeNavigation))]
        public virtual ICollection<Ward> Wards { get; set; }
    }
}
