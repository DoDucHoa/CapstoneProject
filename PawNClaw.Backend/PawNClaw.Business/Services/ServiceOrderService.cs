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
        IServicePriceRepository _servicePriceRepository;
        IPetRepository _petRepository;

        private readonly ApplicationDbContext _db;

        public ServiceOrderService(IServiceOrderRepository serviceOrderRepository, IBookingRepository bookingRepository, 
            IServicePriceRepository servicePriceRepository, IPetRepository petRepository, 
            ApplicationDbContext db)
        {
            _serviceOrderRepository = serviceOrderRepository;
            _bookingRepository = bookingRepository;
            _servicePriceRepository = servicePriceRepository;
            _petRepository = petRepository;
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
                        if (list.Quantity == 0)
                        {
                            _serviceOrderRepository.Remove(updateServiceOrderParameter.BookingId);
                            await _serviceOrderRepository.SaveDbChangeAsync();
                            continue;
                        }

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

                    var bookingToDb = _bookingRepository.Get(booking.Id);

                    bookingToDb.SubTotal = Price;
                    bookingToDb.Total = Price;

                    _bookingRepository.Update(bookingToDb);
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

        //Create Service
        public async Task<bool> CreateServiceOrder(AddNewServiceOrderParameter addNewServiceOrderParameter)
        {
            using (IDbContextTransaction transaction = _db.Database.BeginTransaction())
            {
                foreach (var serviceOrder in addNewServiceOrderParameter.serviceOrderCreateParameters)
                {
                    var pet = _petRepository.Get(serviceOrder.PetId);

                    decimal servicePrice = _servicePriceRepository.GetFirstOrDefault(x => x.ServiceId == serviceOrder.ServiceId
                                                                    && x.MinWeight <= pet.Weight
                                                                    && x.MaxWeight >= pet.Weight).Price;

                    ServiceOrder serviceOrderToDb = new ServiceOrder()
                    {
                        ServiceId = serviceOrder.ServiceId,
                        BookingId = addNewServiceOrderParameter.BookingId,
                        Quantity = serviceOrder.Quantity,
                        SellPrice = servicePrice,
                        TotalPrice = serviceOrder.Quantity * serviceOrder.SellPrice,
                        Note = serviceOrder.Note,
                        PetId = serviceOrder.PetId
                    };

                    try
                    {
                        _serviceOrderRepository.Add(serviceOrderToDb);
                        await _bookingRepository.SaveDbChangeAsync();
                    }
                    catch
                    {
                        transaction.Rollback();
                        return false;
                    }
                }

                try
                {
                    var booking = _bookingRepository.GetBookingForCustomer(addNewServiceOrderParameter.BookingId);

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

                    var bookingToDb = _bookingRepository.Get(booking.Id);

                    bookingToDb.SubTotal = Price;
                    bookingToDb.Total = Price;

                    _bookingRepository.Update(bookingToDb);
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
