using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    [Index(nameof(Id), Name = "i")]
    public partial class Location
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Column("longtitude")]
        [StringLength(64)]
        public string Longtitude { get; set; }
        [Column("latitude")]
        [StringLength(64)]
        public string Latitude { get; set; }
        [Required]
        [Column("city_code")]
        [StringLength(32)]
        public string CityCode { get; set; }
        [Required]
        [Column("district_code")]
        [StringLength(32)]
        public string DistrictCode { get; set; }
        [Required]
        [Column("ward_code")]
        [StringLength(32)]
        public string WardCode { get; set; }

        [ForeignKey(nameof(CityCode))]
        [InverseProperty(nameof(City.Locations))]
        public virtual City CityCodeNavigation { get; set; }
        [ForeignKey(nameof(DistrictCode))]
        [InverseProperty(nameof(District.Locations))]
        public virtual District DistrictCodeNavigation { get; set; }
        [ForeignKey(nameof(Id))]
        [InverseProperty(nameof(PetCenter.Location))]
        public virtual PetCenter IdNavigation { get; set; }
        [ForeignKey(nameof(WardCode))]
        [InverseProperty(nameof(Ward.Locations))]
        public virtual Ward WardCodeNavigation { get; set; }
    }
}
