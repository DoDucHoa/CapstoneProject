﻿using PawNClaw.Data.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Interface
{
    public interface IServiceOrderRepository : IRepository<ServiceOrder>
    {
        public void RemoveServiceOrder(int BookingId, int ServiceId);

        public IEnumerable<ServiceOrder> GetServiceOrdersByPetIdAndBookingId(int BookingId, int PetId);

        public ServiceOrder GetServiceOrder(int BookingId, int ServiceId);
    }
}
