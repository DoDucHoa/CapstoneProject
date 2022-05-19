using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
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

        public bool Confirm(int Id, int StatusId)
        {
            if (_bookingRepository.Confirm(Id, StatusId))
            {
                return true;
            }
            else return false;
        }

        public bool ConfirmBooking(int Id, int StatusId, string StaffNote)
        {
            if (StatusId == 4 && StaffNote == null)
            {
                return false;
            }

            var booking = _bookingRepository.Get(Id);

            booking.StaffNote = StaffNote;

            try
            {
                _bookingRepository.Update(booking);
                _bookingRepository.SaveDbChange();
                if (!Confirm(Id, StatusId))
                {
                    return false;
                }
            }
            catch
            {
                return false;
            }

            return true;
        }

        public PagedList<Booking> GetBookings(BookingRequestParameter bookingRequestParameter, PagingParameter paging)
        {
            var values = _bookingRepository.GetBookingForStaff(bookingRequestParameter);
            return PagedList<Booking>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }
    }
}
