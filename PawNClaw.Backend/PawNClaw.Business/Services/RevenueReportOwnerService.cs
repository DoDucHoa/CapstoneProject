using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class RevenueReportOwnerService
    {
        IBookingRepository _bookingRepository;
        ICageRepository _cageRepository;

        public RevenueReportOwnerService(IBookingRepository bookingRepository, ICageRepository cageRepository)
        {
            _bookingRepository = bookingRepository;
            _cageRepository = cageRepository;
        }

        public BookingCount BookingCount(int centerId, DateTime? from, DateTime? to)
        {
            var booking = _bookingRepository.GetAll(x => x.CenterId == centerId);

            if (from != null && to != null)
            {
                booking = booking.Where(x => (x.StartBooking >= from && x.StartBooking <= to) || (x.EndBooking >= from && x.EndBooking <= to));
            }

            BookingCount bookingCount = new BookingCount()
            {
                TotalBooking = booking.Count()
            };
            return bookingCount;
        }

        public BookingCountWithStatus BookingCountWithStatus(int centerId, DateTime? from, DateTime? to)
        {
            var bookings = _bookingRepository.GetAll(x => x.CenterId == centerId);

            if (from != null && to != null)
            {
                bookings = bookings.Where(x => (x.StartBooking >= from && x.StartBooking <= to) || (x.EndBooking >= from && x.EndBooking <= to));
            }

            BookingCountWithStatus bookingCount = new BookingCountWithStatus()
            {
                TotalPending = bookings.Where(x => x.StatusId == 1).Count(),
                TotalProcessing = bookings.Where(x => x.StatusId == 2).Count(),
                TotalDone = bookings.Where(x => x.StatusId == 3).Count(),
                TotalCancelled = bookings.Where(x => x.StatusId == 4).Count()
            };

            return bookingCount;
        }

        public TotalCageOfCenter TotalCageOfCenter(int centerId, DateTime? from, DateTime? to)
        {
            var cages = _cageRepository.GetAll(x => x.CenterId == centerId && x.Status == true, includeProperties: "BookingDetails,BookingDetails.Booking");

            TotalCageOfCenter totalCageOfCenter = new TotalCageOfCenter()
            {
                TotalCage = cages.Count(),
                TotalCageAvailable = cages.Where(x => x.BookingDetails.Any(detail => 
                                !(((DateTime.Compare((DateTime)from, (DateTime)detail.Booking.StartBooking) <= 0
                                && DateTime.Compare((DateTime)to, (DateTime)detail.Booking.EndBooking) >= 0)
                                ||
                                (DateTime.Compare((DateTime)from, (DateTime)detail.Booking.StartBooking) >= 0
                                && DateTime.Compare((DateTime)from, (DateTime)detail.Booking.EndBooking) < 0)
                                ||
                                (DateTime.Compare((DateTime)to, (DateTime)detail.Booking.StartBooking) > 0
                                && DateTime.Compare((DateTime)to, (DateTime)detail.Booking.EndBooking) <= 0))
                                && (detail.Booking.StatusId == 1 || detail.Booking.StatusId == 2)))).Count()
            };

            return totalCageOfCenter;
        }

        public IEnumerable<Cage> CageFreeOfCenter(int centerId, DateTime? from, DateTime? to)
        {
            var cages = _cageRepository.GetAll(x => x.CenterId == centerId && x.Status == true, includeProperties: "BookingDetails,BookingDetails.Booking");

            cages = cages.Where(x => x.BookingDetails.Any(detail =>
                                !(((DateTime.Compare((DateTime)from, (DateTime)detail.Booking.StartBooking) <= 0
                                && DateTime.Compare((DateTime)to, (DateTime)detail.Booking.EndBooking) >= 0)
                                ||
                                (DateTime.Compare((DateTime)from, (DateTime)detail.Booking.StartBooking) >= 0
                                && DateTime.Compare((DateTime)from, (DateTime)detail.Booking.EndBooking) < 0)
                                ||
                                (DateTime.Compare((DateTime)to, (DateTime)detail.Booking.StartBooking) > 0
                                && DateTime.Compare((DateTime)to, (DateTime)detail.Booking.EndBooking) <= 0))
                                && (detail.Booking.StatusId == 1 || detail.Booking.StatusId == 2))));
            

            return cages.ToList();
        }

        public IncomeOfCenter IncomeOfCenter(int centerId)
        {
            var bookings = _bookingRepository.GetAll(x => x.CenterId == centerId && x.StatusId == 3);

            DateTime today = DateTime.Today;

            IncomeOfCenter incomeOfCenter = new IncomeOfCenter()
            {
                IncomeOfMonth = bookings.Where(x => ((DateTime)x.StartBooking).Month == today.Month
                                                && ((DateTime)x.StartBooking).Year == today.Year)
                                        .Sum(x => x.Total),
                IncomeOfYear = bookings.Where(x => ((DateTime)x.StartBooking).Year == today.Year)
                                        .Sum(x => x.Total),
                PercentWithLastMonth = (float?)(((bookings.Where(x => ((DateTime)x.StartBooking).Month == today.Month
                                                && ((DateTime)x.StartBooking).Year == today.Year)
                                        .Sum(x => x.Total)) / (bookings.Where(x => ((DateTime)x.StartBooking).Month == today.AddMonths(-1).Month
                                                && ((DateTime)x.StartBooking).Year == today.Year)
                                        .Sum(x => x.Total)))) - 1
            };

            return incomeOfCenter;
        }

        public IncomeOfCenter IncomeOfCenterCustomeMonth(int centerId, DateTime date)
        {
            var bookings = _bookingRepository.GetAll(x => x.CenterId == centerId && x.StatusId == 3);

            IncomeOfCenter incomeOfCenter = new IncomeOfCenter()
            {
                IncomeOfMonth = bookings.Where(x => ((DateTime)x.StartBooking).Month == date.Month
                                                && ((DateTime)x.StartBooking).Year == date.Year)
                                        .Sum(x => x.Total),
                IncomeOfYear = bookings.Where(x => ((DateTime)x.StartBooking).Year == date.Year)
                                        .Sum(x => x.Total),
                PercentWithLastMonth = (float?)(((bookings.Where(x => ((DateTime)x.StartBooking).Month == date.Month
                                                && ((DateTime)x.StartBooking).Year == date.Year)
                                        .Sum(x => x.Total)) / (bookings.Where(x => ((DateTime)x.StartBooking).Month == date.AddMonths(-1).Month
                                                && ((DateTime)x.StartBooking).Year == date.Year)
                                        .Sum(x => x.Total)))) - 1
            };

            return incomeOfCenter;
        }
    }
}
