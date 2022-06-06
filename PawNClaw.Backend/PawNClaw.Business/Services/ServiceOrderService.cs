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
    public class ServiceOrderService
    {
        IServiceOrderRepository _serviceOrderRepository;
        IBookingRepository _bookingRepository;

        private readonly ApplicationDbContext _db;

        public ServiceOrderService(IServiceOrderRepository serviceOrderRepository,
            IBookingRepository bookingRepository, ApplicationDbContext db)
        {
            _serviceOrderRepository = serviceOrderRepository;
            _bookingRepository = bookingRepository;
            _db = db;
        }

        //Update Service Order For Staff
        public async Task<bool> UpdateServiceOrderForStaff(UpdateServiceOrderParameter updateServiceOrderParameter)
        {

            using (IDbContextTransaction transaction = _db.Database.BeginTransaction())
            {
                foreach (var list in updateServiceOrderParameter.listUpdateServiceOrderParameters)
                {
                    try
                    {
                        var values = _serviceOrderRepository.GetFirstOrDefault(x => x.BookingId == updateServiceOrderParameter.BookingId
                                                                        && x.ServiceId == list.ServiceId);

                        values.Quantity = list.Quantity;
                        values.SellPrice = list.SellPrice;
                        values.TotalPrice = list.Quantity * list.SellPrice;

                        _serviceOrderRepository.Update(values);
                        await _serviceOrderRepository.SaveDbChangeAsync();
                    }
                    catch
                    {
                        transaction.Rollback();
                        return false;
                    }
                }

                try
                {
                    var booking = _bookingRepository.GetBookingForCustomer(updateServiceOrderParameter.BookingId);

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
