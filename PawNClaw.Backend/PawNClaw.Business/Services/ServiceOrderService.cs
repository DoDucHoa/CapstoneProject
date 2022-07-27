using Microsoft.EntityFrameworkCore.Storage;
using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class ServiceOrderService
    {
        IServiceOrderRepository _serviceOrderRepository;
        IBookingRepository _bookingRepository;
        IServicePriceRepository _servicePriceRepository;
        IPetRepository _petRepository;
        IVoucherRepository _voucherRepository;

        private readonly ApplicationDbContext _db;

        public ServiceOrderService(IServiceOrderRepository serviceOrderRepository, IBookingRepository bookingRepository, 
            IServicePriceRepository servicePriceRepository, IPetRepository petRepository, 
            IVoucherRepository voucherRepository,
            ApplicationDbContext db)
        {
            _serviceOrderRepository = serviceOrderRepository;
            _bookingRepository = bookingRepository;
            _servicePriceRepository = servicePriceRepository;
            _petRepository = petRepository;
            _voucherRepository = voucherRepository;
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
                            _serviceOrderRepository.RemoveServiceOrder(updateServiceOrderParameter.BookingId, list.ServiceId);
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

                    decimal Discount = 0;
                    //Here Check Voucher
                    if (bookingToDb.VoucherCode != null)
                    {
                        var voucher = _voucherRepository.Get(bookingToDb.VoucherCode);

                        if (voucher.VoucherTypeCode.Equals("1"))
                        {
                            if (Price > voucher.MinCondition)
                            {
                                Discount = (decimal)(Price * (voucher.Value / 100));
                            }
                        }

                        if (voucher.VoucherTypeCode.Equals("2"))
                        {
                            if (Price > voucher.MinCondition)
                            {
                                Discount = (decimal)(Price - voucher.Value);
                            }
                        }
                    }

                    bookingToDb.SubTotal = Price;
                    bookingToDb.Discount = Discount;
                    bookingToDb.Total = Price - Discount;

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
