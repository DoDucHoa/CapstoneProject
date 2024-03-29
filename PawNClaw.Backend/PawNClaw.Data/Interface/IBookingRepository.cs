﻿using PawNClaw.Data.Database;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Interface
{
    public interface IBookingRepository : IRepository<Booking>
    {
        public IEnumerable<Booking> GetBookingValidSearch(int Id, DateTime _startBooking, DateTime _endBooking);

        public bool Confirm(int Id, int StatusId);

        public IEnumerable<Booking> GetBookingForStaff(BookingRequestParameter bookingRequestParameter);

        public Booking GetBookingForCustomer(int BookingId);

        public Booking GetBookingForStaff(int BookingId);

        public IEnumerable<Booking> GetBookingByCenterIdForStaff(int CenterId, int? StatusId);

        public IEnumerable<Booking> GetBookingByCustomerId(int CustomerId, int? StatusId);

        public Booking GetBookingForCreateActivity(int BookingId);

        public Booking GetBookingByCageCodeForStaff(int CenterId, int? StatusId, string CageCode);

        public IEnumerable<Booking> GetCenterReviews(int centerId);
    }
}
