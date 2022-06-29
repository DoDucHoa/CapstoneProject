using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    public partial class Photo
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Column("photo_type_id")]
        public int PhotoTypeId { get; set; }
        [Column("id_actor")]
        public int IdActor { get; set; }
        [Required]
        [Column("url")]
        [StringLength(512)]
        public string Url { get; set; }
        [Column("isThumbnail")]
        public bool? IsThumbnail { get; set; }
        [Column("status")]
        public bool? Status { get; set; }

        [ForeignKey(nameof(PhotoTypeId))]
        [InverseProperty("Photos")]
        public virtual PhotoType PhotoType { get; set; }
    }
}
