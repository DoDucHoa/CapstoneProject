using PawNClaw.Data.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.DataObject
{
    public class PetCenterData
    {
        public PetCenter PetCenter { get; set; }
        public int RatingCount { get => _getRatingCount(this.PetCenter.Bookings); }

        private int _getRatingCount(ICollection<Booking> Bookings)
        {
            int count = 0;
            foreach (var booking in Bookings)
            {
                if (booking.Rating.HasValue)
                {
                    count++;
                }
            }
            return count;
        }
    }
}
