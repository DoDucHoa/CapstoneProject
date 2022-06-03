using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class BookingStatusService
    {
        IBookingStatusRepository _bookingStatusRepository;
        public BookingStatusService(IBookingStatusRepository bookingStatusRepository)
        {
            _bookingStatusRepository = bookingStatusRepository;
        }

        public IEnumerable<BookingStatus> GetBookingStatuses()
        {
            var values = _bookingStatusRepository.GetAll();

            return values;
        }
    }
}
