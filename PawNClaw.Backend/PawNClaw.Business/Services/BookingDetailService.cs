using Microsoft.EntityFrameworkCore.Storage;
using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class BookingDetailService
    {
        IBookingDetailRepository _bookingDetailRepository;
        IPetBookingDetailRepository _petBookingDetailRepository;
        IPetRepository _petRepository;
        ICageRepository _cageRepository;
        IBookingRepository _bookingRepository;
        IVoucherRepository _voucherRepository;

        private readonly ApplicationDbContext _db;

        public BookingDetailService(IBookingDetailRepository bookingDetailRepository,
            IPetBookingDetailRepository petBookingDetailRepository, IPetRepository petRepository,
            ICageRepository cageRepository, IBookingRepository bookingRepository,
            IVoucherRepository voucherRepository,
            ApplicationDbContext db)
        {
            _bookingDetailRepository = bookingDetailRepository;
            _petBookingDetailRepository = petBookingDetailRepository;
            _petRepository = petRepository;
            _cageRepository = cageRepository;
            _bookingRepository = bookingRepository;
            _voucherRepository = voucherRepository;
            _db = db;
        }

        //Get By Booking Id
        public IEnumerable<BookingDetail> GetBookingDetailsByBookingId(int BookingId)
        {
            var values = _bookingDetailRepository.GetAll(x => x.BookingId == BookingId);

            return values.ToList();
        }

        //Get By Booking Detail Id
        public IEnumerable<BookingDetail> GetBookingDetailsById(int BookingDetailId)
        {
            var values = _bookingDetailRepository.GetAll(x => x.Id == BookingDetailId);

            return values.ToList();
        }

        //Update New Cage For Booking Detail
        public async Task<bool> UpdateCageOfBookingDetail(UpdateBookingDetailParameter updateBookingDetailParameter)
        {
            var value = _bookingDetailRepository.Get(updateBookingDetailParameter.Id);

            //var petbookingdetails = _petBookingDetailRepository.GetAll(x => x.BookingId == updateBookingDetailParameter.BookingId
            //                                                        && x.Line == updateBookingDetailParameter.Line);

            //decimal PetHeight = 0;
            //decimal PetWidth = 0;
            //foreach (var petbookingdetail in petbookingdetails)
            //{
            //    //Get Size Pet With Cage
            //    var pet = _petRepository.Get(petbookingdetail.PetId);

            //    if (PetHeight < (decimal)(pet.Height + SearchConst.HeightAdd))
            //    {
            //        PetHeight = (decimal)(pet.Height + SearchConst.HeightAdd);
            //    }

            //    PetWidth += (decimal)Math.Round((((double)pet.Length) + ((double)pet.Height)) / SearchConst.WidthRatio, 0);
            //    //End Get Size

            //    //Check Size Is Avaliable
            //    var cage = _cageRepository.GetCageWithCageType(updateBookingDetailParameter.CageCode, value.CenterId);

            //    decimal CageHeight = cage.CageType.Height;
            //    decimal CageWidth = cage.CageType.Width;

            //    if (PetHeight > CageHeight || PetWidth > CageWidth)
            //    {
            //        throw new Exception("Pet Not Fix With Cage Size");
            //    }
            //}

            value.Price = updateBookingDetailParameter.Price * value.Duration;
            value.CageCode = updateBookingDetailParameter.CageCode;
            value.Note = updateBookingDetailParameter.Note;
            using (IDbContextTransaction transaction = _db.Database.BeginTransaction())
            {
                try
                {
                    _bookingDetailRepository.Update(value);
                    await _bookingDetailRepository.SaveDbChangeAsync();

                    var booking = _bookingRepository.GetBookingForCustomer(value.BookingId);

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
                                Discount = (decimal)(voucher.Value);
                            }
                        }
                    }

                    bookingToDb.SubTotal = Price;
                    bookingToDb.Discount = Discount;
                    bookingToDb.Total = Price - Discount;

                    _bookingRepository.Update(bookingToDb);
                    await _bookingRepository.SaveDbChangeAsync();

                    transaction.Commit();
                    return true;
                }
                catch
                {
                    transaction.Rollback();
                    throw new Exception();
                }
            }
        }
    }
}
