﻿using PawNClaw.Data.Database;
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

        //Get Pet By Booking Detail Id
        public IEnumerable<PetBookingDetail> GetPetBookingDetailsByBookingId(int BookingDetailId)
        {
            var values = _petBookingDetailRepository.GetPetBookingDetailsByBookingId(BookingDetailId);

            return values;
        }
    }
}
