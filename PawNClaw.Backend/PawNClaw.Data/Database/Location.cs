using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    [Table("Location")]
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
        [Column("city_id")]
        public int? CityId { get; set; }
        [Column("district_id")]
        public int? DistrictId { get; set; }
        [Column("ward_id")]
        public int? WardId { get; set; }

        [ForeignKey(nameof(Id))]
        [InverseProperty(nameof(PetCenter.Location))]
        public virtual PetCenter IdNavigation { get; set; }
    }
}
