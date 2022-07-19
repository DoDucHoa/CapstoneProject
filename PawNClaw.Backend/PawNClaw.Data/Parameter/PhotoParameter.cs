using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    class PhotoParameter
    {
    }

    public class CreatePhotoParameter
    {
        public int PhotoTypeId { get; set; }
        public int? IdActor { get; set; }
        public string Url { get; set; }
        public bool? IsThumbnail { get; set; }
    }

    public class UpdatePhotoParameter
    {
        public int Id { get; set; }
        public string Url { get; set; }
    }
}
