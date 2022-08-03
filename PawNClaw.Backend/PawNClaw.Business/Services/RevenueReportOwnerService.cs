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

        public BookingCount BookingCount(int centerId)
        {
            var bookingC = _bookingRepository.GetAll(x => x.CenterId == centerId).Count();
            BookingCount bookingCount = new BookingCount()
            {
                TotalBooking = bookingC
            };
            return bookingCount;
        }

        public BookingCountWithStatus BookingCountWithStatus(int centerId)
        {
            var bookings = _bookingRepository.GetAll(x => x.CenterId == centerId);

            BookingCountWithStatus bookingCount = new BookingCountWithStatus()
            {
                TotalPending = bookings.Where(x => x.StatusId == 1).Count(),
                TotalProcessing = bookings.Where(x => x.StatusId == 2).Count(),
                TotalDone = bookings.Where(x => x.StatusId == 3).Count(),
                TotalCancelled = bookings.Where(x => x.StatusId == 4).Count()
            };

            return bookingCount;
        }

        public TotalCageOfCenter TotalCageOfCenter(int centerId)
        {
            var cageC = _cageRepository.GetAll(x => x.CenterId == centerId && x.Status == true).Count();

            TotalCageOfCenter totalCageOfCenter = new TotalCageOfCenter()
            {
                TotalCage = cageC
            };

            return totalCageOfCenter;
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
    }
}
