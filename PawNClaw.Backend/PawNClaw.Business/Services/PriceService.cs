using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class PriceService
    {
        IPriceRepository _priceRepository;

        public PriceService(IPriceRepository priceRepository)
        {
            _priceRepository = priceRepository;
        }

        public IEnumerable<Price> GetPriceByCageType(int cageTypeId)
        {
            return _priceRepository.GetAll(x => x.CageTypeId == cageTypeId);
        }

        public Price GetPriceById(int id)
        {
            return _priceRepository.Get(id);
        }

        public bool CreatePrice(Price price)
        {
            _priceRepository.Add(price);
            _priceRepository.SaveDbChange();
            return true;
        }

        public bool UpdatePrice(Price price)
        {
            _priceRepository.Update(price);
            _priceRepository.SaveDbChange();
            return true;
        }

        public bool DeletePrice(int id)
        {
            var price = _priceRepository.Get(id);

            if (_priceRepository.GetAll(x => x.CageTypeId == price.CageTypeId && x.PriceTypeCode.Equals("PRICE-001")).Count() < 1)
            {
                throw new Exception("Need one price for Cage Type");
            }

            price.Status = false;

            _priceRepository.Update(price);
            _priceRepository.SaveDbChange();
            return true;
        }
    }
}
