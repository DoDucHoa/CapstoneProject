using PawNClaw.Data.Const;
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
    public class BookingDetailService
    {
        IBookingDetailRepository _bookingDetailRepository;
        IPetBookingDetailRepository _petBookingDetailRepository;
        IPetRepository _petRepository;
        ICageRepository _cageRepository;

        public BookingDetailService(IBookingDetailRepository bookingDetailRepository,
            IPetBookingDetailRepository petBookingDetailRepository, IPetRepository petRepository,
            ICageRepository cageRepository)
        {
            _bookingDetailRepository = bookingDetailRepository;
            _petBookingDetailRepository = petBookingDetailRepository;
            _petRepository = petRepository;
            _cageRepository = cageRepository;
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
        public bool UpdateCageOfBookingDetail(UpdateBookingDetailParameter updateBookingDetailParameter)
        {
            var value = _bookingDetailRepository.GetBookingDetail(updateBookingDetailParameter.BookingId, updateBookingDetailParameter.Line);

            var petbookingdetails = _petBookingDetailRepository.GetAll(x => x.BookingId == updateBookingDetailParameter.BookingId
                                                                    && x.Line == updateBookingDetailParameter.Line);

            decimal PetHeight = 0;
            decimal PetWidth = 0;
            foreach (var petbookingdetail in petbookingdetails)
            {
                //Get Size Pet With Cage
                var pet = _petRepository.Get(petbookingdetail.PetId);

                if (PetHeight < (decimal)(pet.Height + SearchConst.HeightAdd))
                {
                    PetHeight = (decimal)(pet.Height + SearchConst.HeightAdd);
                }

                PetWidth += (decimal)Math.Round((((double)pet.Length) + ((double)pet.Height)) / SearchConst.WidthRatio, 0);
                //End Get Size

                //Check Size Is Avaliable
                var cage = _cageRepository.GetCageWithCageType(updateBookingDetailParameter.CageCode, value.CenterId);

                decimal CageHeight = cage.CageType.Height;
                decimal CageWidth = cage.CageType.Width;

                if (PetHeight > CageHeight || PetWidth > CageWidth)
                {
                    throw new Exception("Pet Not Fix With Cage Size");
                }
            }

            value.Price = updateBookingDetailParameter.Price;
            value.CageCode = updateBookingDetailParameter.CageCode;
            value.Duration = updateBookingDetailParameter.Duration;
            value.Note = updateBookingDetailParameter.Note;

            try
            {
                _bookingDetailRepository.Update(value);
                _bookingDetailRepository.SaveDbChange();
                return true;
            }
            catch
            {
                throw new Exception();
            }
        }
    }
}
