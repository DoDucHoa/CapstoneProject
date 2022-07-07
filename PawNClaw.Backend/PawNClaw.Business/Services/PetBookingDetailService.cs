using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System.Collections.Generic;

namespace PawNClaw.Business.Services
{
    public class PetBookingDetailService
    {
        IPetBookingDetailRepository _petBookingDetailRepository;

        public PetBookingDetailService(IPetBookingDetailRepository petBookingDetailRepository)
        {
            _petBookingDetailRepository = petBookingDetailRepository;
        }

        //Get Pet By Booking Id
        public IEnumerable<PetBookingDetail> GetPetBookingDetailsByBookingId(int BookingId)
        {
            var values = _petBookingDetailRepository.GetPetBookingDetailsByBookingId(BookingId);

            return values;
        }
    }
}
