using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    [Table("Ward")]
    public partial class Ward
    {
        public Ward()
        {
            Locations = new HashSet<Location>();
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
        [Required]
        [Column("district_code")]
        [StringLength(32)]
        public string DistrictCode { get; set; }

        [ForeignKey(nameof(CityCode))]
        [InverseProperty(nameof(City.Wards))]
        public virtual City CityCodeNavigation { get; set; }
        [ForeignKey(nameof(DistrictCode))]
        [InverseProperty(nameof(District.Wards))]
        public virtual District DistrictCodeNavigation { get; set; }
        [InverseProperty(nameof(Location.WardCodeNavigation))]
        public virtual ICollection<Location> Locations { get; set; }
    }
}
