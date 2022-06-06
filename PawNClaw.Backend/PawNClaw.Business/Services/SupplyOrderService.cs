using Microsoft.EntityFrameworkCore.Storage;
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
    public class SupplyOrderService
    {
        ISupplyOrderRepository _supplyOrderRepository;
        IBookingRepository _bookingRepository;

        private readonly ApplicationDbContext _db;

        public SupplyOrderService(ISupplyOrderRepository supplyOrderRepository, 
            IBookingRepository bookingRepository, ApplicationDbContext db)
        {
            _supplyOrderRepository = supplyOrderRepository;
            _bookingRepository = bookingRepository;
            _db = db;
        }

        //Update Supply Order For Staff
        public async Task<bool> UpdateSupplyOrderForStaff(UpdateSupplyOrderParameter updateSupplyOrderParameter)
        {

            using (IDbContextTransaction transaction = _db.Database.BeginTransaction())
            {
                foreach (var list in updateSupplyOrderParameter.listUpdateSupplyOrderParameters)
                {
                    try
                    {
                        var values = _supplyOrderRepository.GetFirstOrDefault(x => x.BookingId == updateSupplyOrderParameter.BookingId
                                                                        && x.SupplyId == list.ServiceId);

                        values.Quantity = list.Quantity;
                        values.SellPrice = list.SellPrice;
                        values.TotalPrice = list.Quantity * list.SellPrice;

                        _supplyOrderRepository.Update(values);
                        await _supplyOrderRepository.SaveDbChangeAsync();
                    }
                    catch
                    {
                        transaction.Rollback();
                        return false;
                    }
                }

                try
                {
                    var booking = _bookingRepository.GetBookingForCustomer(updateSupplyOrderParameter.BookingId);

                    var serviceOrders = booking.ServiceOrders;

                    var supplyOrders = booking.SupplyOrders;

                    var bookingDetails = booking.BookingDetails;

                    decimal Price = 0;

                    foreach (var serviceOrder in serviceOrders)
                    {
                        Price = (decimal)(Price + serviceOrder.TotalPrice);
                    }

                    foreach (var supplyOrder in supplyOrders)
                    {
                        Price = (decimal)(Price + supplyOrder.TotalPrice);
                    }

                    foreach (var bookingDetail in bookingDetails)
                    {
                        Price = (decimal)(Price + bookingDetail.Price);
                    }

                    booking.SubTotal = Price;
                    booking.Total = Price;

                    _bookingRepository.Update(booking);
                    await _bookingRepository.SaveDbChangeAsync();
                }
                catch
                {
                    transaction.Rollback();
                    return false;
                }


                transaction.Commit();
            }

            return true;
        }
    }
}
