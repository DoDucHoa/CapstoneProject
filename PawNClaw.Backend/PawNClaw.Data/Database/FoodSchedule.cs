using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    [Table("FoodSchedule")]
    public partial class FoodSchedule
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Column("from_time")]
        public TimeSpan FromTime { get; set; }
        [Column("to_time")]
        public TimeSpan ToTime { get; set; }
        [Column("name")]
        [StringLength(256)]
        public string Name { get; set; }
        [Column("cage_type_id")]
        public int CageTypeId { get; set; }

        [ForeignKey(nameof(CageTypeId))]
        [InverseProperty("FoodSchedules")]
        public virtual CageType CageType { get; set; }
    }
}
