using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System.Collections.Generic;
using System.Linq;

namespace PawNClaw.Business.Services
{
    public class ServicePriceService
    {
        IServicePriceRepository _servicePriceRepository;

        public ServicePriceService(IServicePriceRepository servicePriceRepository)
        {
            _servicePriceRepository = servicePriceRepository;
        }

        //Get All Price Ò Service
        public IEnumerable<ServicePrice> GetPriceOfService(int ServiceId)
        {
            var values = _servicePriceRepository.GetAll(x => x.ServiceId == ServiceId && x.Status == true);

            return values.ToList();
        }
    }
}
