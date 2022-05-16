using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class BookingService
    {
        IBookingRepository _bookingRepository;

        public BookingService(IBookingRepository bookingRepository)
        {
            _bookingRepository = bookingRepository;
        }

        public bool ConfirmBooking(int Id, int StatusId)
        {
            if (_bookingRepository.ConfirmBooking(Id, StatusId))
            {
                return true;
            }
            else return false;
        }
    }
}
