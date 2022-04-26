using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

#nullable disable

namespace PawNClaw.Data.Database
{
    [Table("PhotoType")]
    public partial class PhotoType
    {
        public PhotoType()
        {
            Photos = new HashSet<Photo>();
        }

        [Key]
        [Column("id")]
        public int Id { get; set; }
        [Column("name")]
        [StringLength(256)]
        public string Name { get; set; }
        [Column("status")]
        public bool? Status { get; set; }

        [InverseProperty(nameof(Photo.PhotoType))]
        public virtual ICollection<Photo> Photos { get; set; }
    }
}
