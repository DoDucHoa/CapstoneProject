﻿using Microsoft.EntityFrameworkCore.Storage;
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

        private readonly ApplicationDbContext _db;

        public BookingDetailService(IBookingDetailRepository bookingDetailRepository,
            IPetBookingDetailRepository petBookingDetailRepository, IPetRepository petRepository,
            ICageRepository cageRepository, IBookingRepository bookingRepository,
            ApplicationDbContext db)
        {
            _bookingDetailRepository = bookingDetailRepository;
            _petBookingDetailRepository = petBookingDetailRepository;
            _petRepository = petRepository;
            _cageRepository = cageRepository;
            _bookingRepository = bookingRepository;
            _db = db;
        }

        //Get By Booking Id
        public IEnumerable<BookingDetail> GetBookingDetailsByBookingId(int BookingId)
        {
            var values = _bookingDetailRepository.GetAll(x => x.BookingId == BookingId);

            return values.ToList();
        }

        //Get By Booking Id And Line
        public IEnumerable<BookingDetail> GetBookingDetailsByBookingIdAndLine(int BookingId, int Line)
        {
            var values = _bookingDetailRepository.GetAll(x => x.BookingId == BookingId && x.Line == Line);

            return values.ToList();
        }

        //Update New Cage For Booking Detail
        public async Task<bool> UpdateCageOfBookingDetail(UpdateBookingDetailParameter updateBookingDetailParameter)
        {
            var value = _bookingDetailRepository.GetBookingDetail(updateBookingDetailParameter.BookingId,
                updateBookingDetailParameter.Line);

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

            value.Price = updateBookingDetailParameter.Price;
            value.CageCode = updateBookingDetailParameter.CageCode;
            value.Note = updateBookingDetailParameter.Note;
            using (IDbContextTransaction transaction = _db.Database.BeginTransaction())
            {
                try
                {
                    _bookingDetailRepository.Update(value);
                    await _bookingDetailRepository.SaveDbChangeAsync();

                    var booking = _bookingRepository.GetBookingForCustomer(updateBookingDetailParameter.BookingId);

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
