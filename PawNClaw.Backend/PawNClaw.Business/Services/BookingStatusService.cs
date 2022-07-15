using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System.Collections.Generic;

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
