using PawNClaw.Data.Const;
using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class PriceRepository : Repository<Price>, IPriceRepository
    {
        public PriceRepository(ApplicationDbContext db) : base(db)
        {
        }

        public string checkTotalPriceOfCageType(int CageTypeId, string StartBooking, string EndBooking)
        {

            IQueryable<Price> query = _dbSet.Where(x => x.CageTypeId == CageTypeId && x.Status == true);

            DateTime _startBooking = DateTime.ParseExact(StartBooking, SearchConst.DateFormat,
                                       System.Globalization.CultureInfo.InvariantCulture);

            DateTime _endBooking = DateTime.ParseExact(EndBooking, SearchConst.DateFormat,
                                       System.Globalization.CultureInfo.InvariantCulture);

            //TimeSpan diffOfDates = _endBooking.TimeOfDay.Subtract(_startBooking.TimeOfDay);


            decimal TotalPrice = 0;
            decimal? unitPrice = null;
            try
            {

                for (var dt = _startBooking; dt.Date <= _endBooking.Date; dt = dt.AddDays(1))
                {
                    //Check if have any price is specify date
                    if (query.Any(x => x.PriceTypeCode.Equals("PRICE-004")))
                    {
                        unitPrice = query.Where(x => x.DateFrom <= dt.Date && x.DateTo >= dt.Date)
                                                    .FirstOrDefault().UnitPrice;

                        //Check if have specify date price and the date booking equal with that day
                        if (unitPrice != null)
                        {
                            TotalPrice = (decimal)(TotalPrice + unitPrice);
                            continue;
                        }
                    }
                    //Here is no type specify date
                    if (query.Any(x => x.PriceTypeCode.Equals("PRICE-003")))
                    {
                        //Here check the booking date is equal with the day of week
                        //Xu ly check thu o day hien tai null
                        unitPrice = null;
                        if (unitPrice != null)
                        {
                            TotalPrice = (decimal)(TotalPrice + unitPrice);
                            continue;
                        }
                    }
                    if (query.Any(x => x.PriceTypeCode.Equals("PRICE-002")))
                    {
                        if (dt.DayOfWeek == DayOfWeek.Saturday || dt.DayOfWeek == DayOfWeek.Sunday)
                        {
                            unitPrice = query.Where(x => x.PriceTypeCode.Equals("PRICE-002"))
                                    .FirstOrDefault().UnitPrice;
                            TotalPrice = (decimal)(TotalPrice + unitPrice);
                            continue;
                        }
                    }

                    unitPrice = query.Where(x => x.PriceTypeCode.Equals("PRICE-001"))
                            .FirstOrDefault().UnitPrice;
                    TotalPrice = (decimal)(TotalPrice + unitPrice);
                    continue;
                }


                //****************************************************************************
                //Here Check First Date Booking
            //    if (query.Any(x => x.PriceTypeCode.Equals("PRICE-004")))
            //    {
            //        unitPrice = query.Where(x => x.DateFrom <= _startBooking.Date && x.DateTo >= _startBooking.Date)
            //                                    .FirstOrDefault().UnitPrice;

            //        //Check if have specify date price and the date booking equal with that day
            //        if (unitPrice != null)
            //        {
            //            TotalPrice = (decimal)(TotalPrice + unitPrice * (24 - _startBooking.Hour));
            //            if (_startBooking.Minute == 30)
            //            {
            //                TotalPrice = (decimal)(TotalPrice + unitPrice / 2);
            //            }
            //        }
            //    }
            //    //Here is no type specify date
            //    if (query.Any(x => x.PriceTypeCode.Equals("PRICE-003")))
            //    {
            //        //Here check the booking date is equal with the day of week
            //        //Xu ly check thu o day hien tai null
            //        unitPrice = null;
            //        if (unitPrice != null)
            //        {
            //            TotalPrice = (decimal)(TotalPrice + unitPrice * (24 - _startBooking.Hour));
            //            if (_startBooking.Minute == 30)
            //            {
            //                TotalPrice = (decimal)(TotalPrice + unitPrice / 2);
            //            }
            //        }
            //    }
            //    if (query.Any(x => x.PriceTypeCode.Equals("PRICE-002")))
            //    {
            //        if (_startBooking.DayOfWeek == DayOfWeek.Saturday || _startBooking.DayOfWeek == DayOfWeek.Sunday)
            //        {
            //            unitPrice = query.Where(x => x.PriceTypeCode.Equals("PRICE-002"))
            //                    .FirstOrDefault().UnitPrice;
            //            TotalPrice = (decimal)(TotalPrice + unitPrice * (24 - _startBooking.Hour));
            //            if (_startBooking.Minute == 30)
            //            {
            //                TotalPrice = (decimal)(TotalPrice + unitPrice / 2);
            //            }
            //        }
            //    }

            //    unitPrice = query.Where(x => x.PriceTypeCode.Equals("PRICE-001"))
            //            .FirstOrDefault().UnitPrice;
            //    TotalPrice = (decimal)(TotalPrice + unitPrice * (24 - _startBooking.Hour));
            //    if (_startBooking.Minute == 30)
            //    {
            //        TotalPrice = (decimal)(TotalPrice + unitPrice / 2);
            //    }

            //    //****************************************************************************************************
            //    //Here Check Last Date Booking
            //    if (query.Any(x => x.PriceTypeCode.Equals("PRICE-004")))
            //    {
            //        unitPrice = query.Where(x => x.DateFrom <= _endBooking.Date && x.DateTo >= _endBooking.Date)
            //                                    .FirstOrDefault().UnitPrice;

            //        //Check if have specify date price and the date booking equal with that day
            //        if (unitPrice != null)
            //        {
            //            TotalPrice = (decimal)(TotalPrice + unitPrice * _endBooking.Hour);
            //            if (_endBooking.Minute == 30)
            //            {
            //                TotalPrice = (decimal)(TotalPrice + unitPrice / 2);
            //            }
            //        }
            //    }
            //    //Here is no type specify date
            //    if (query.Any(x => x.PriceTypeCode.Equals("PRICE-003")))
            //    {
            //        //Here check the booking date is equal with the day of week
            //        //Xu ly check thu o day hien tai null
            //        unitPrice = null;
            //        if (unitPrice != null)
            //        {
            //            TotalPrice = (decimal)(TotalPrice + unitPrice * _endBooking.Hour);
            //            if (_endBooking.Minute == 30)
            //            {
            //                TotalPrice = (decimal)(TotalPrice + unitPrice / 2);
            //            }
            //        }
            //    }
            //    if (query.Any(x => x.PriceTypeCode.Equals("PRICE-002")))
            //    {
            //        if (_endBooking.DayOfWeek == DayOfWeek.Saturday || _endBooking.DayOfWeek == DayOfWeek.Sunday)
            //        {
            //            unitPrice = query.Where(x => x.PriceTypeCode.Equals("PRICE-002"))
            //                    .FirstOrDefault().UnitPrice;
            //            TotalPrice = (decimal)(TotalPrice + unitPrice * _endBooking.Hour);
            //            if (_endBooking.Minute == 30)
            //            {
            //                TotalPrice = (decimal)(TotalPrice + unitPrice / 2);
            //            }
            //        }
            //    }

            //    unitPrice = query.Where(x => x.PriceTypeCode.Equals("PRICE-001"))
            //            .FirstOrDefault().UnitPrice;
            //    TotalPrice = (decimal)(TotalPrice + unitPrice * _endBooking.Hour);
            //    if (_endBooking.Minute == 30)
            //    {
            //        TotalPrice = (decimal)(TotalPrice + unitPrice / 2);
            //    }
            }
            catch
            {
                throw new Exception();
            }

            return TotalPrice.ToString();
        }
    }
}
