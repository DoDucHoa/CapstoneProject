using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
