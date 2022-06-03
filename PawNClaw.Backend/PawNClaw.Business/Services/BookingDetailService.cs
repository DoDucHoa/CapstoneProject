using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class BookingDetailService
    {
        IBookingDetailRepository _bookingDetailRepository;

        public BookingDetailService(IBookingDetailRepository bookingDetailRepository)
        {
            _bookingDetailRepository = bookingDetailRepository;
        }


        //Get By Booking Id
        public IEnumerable<BookingDetail> GetBookingDetailsByBookingId(int BookingId)
        {
            var values = _bookingDetailRepository.GetAll(x => x.BookingId == BookingId);

            return values.ToList();
        }

        //Get By Booking Id And Line
        public IEnumerable<BookingDetail> GetBookingDetailsByBookingIdAndLine(int BookingId, int Line)
        {
            var values = _bookingDetailRepository.GetAll(x => x.BookingId == BookingId && x.Line == Line);

            return values.ToList();
        }
    }
}
