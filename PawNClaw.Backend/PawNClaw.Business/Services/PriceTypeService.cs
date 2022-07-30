using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class PriceTypeService
    {
        IPriceTypeRepository _priceTypeRepository;

        public PriceTypeService(IPriceTypeRepository priceTypeRepository)
        {
            _priceTypeRepository = priceTypeRepository;
        }

        public List<PriceType> getPriceTypes()
        {
            var values = _priceTypeRepository.GetAll().Where(x => x.Status == true);

            return values.ToList();
        }
    }
}
