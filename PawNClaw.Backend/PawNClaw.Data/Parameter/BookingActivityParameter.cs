using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    class BookingActivityParameter
    {
    }

    public class CreateBookingActivityParameter
    {
        public DateTime? ProvideTime { get; set; }
        public string Description { get; set; }
        public int BookingId { get; set; }
        public int? BookingDetailId { get; set; }
        public int? PetId { get; set; }
        public int? SupplyId { get; set; }
        public int? ServiceId { get; set; }
    }

    public class CreateBookingActivityControllerParameter
    {
        public CreateBookingActivityParameter createBookingActivityParameter { get; set; }
        public CreatePhotoParameter createPhotoParameter { get; set; }
    }

    public class UpdateBookingActivityParameter
    {
        public int Id { get; set; }
        public DateTime? ProvideTime { get; set; }
        public string Description { get; set; }

        public CreatePhotoParameter createPhotoParameter { get; set; }
    }
}
