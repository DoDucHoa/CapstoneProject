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
    public class SupplyService
    {
        ISupplyRepository _supplyRepository;

        public SupplyService(ISupplyRepository supplyRepository)
        {
            _supplyRepository = supplyRepository;
        }

        public IEnumerable<Supply> GetSupplyOfCenter(int CenterId)
        {
            try
            {
                return _supplyRepository.GetAll(x => x.CenterId == CenterId);
            }
            catch
            {
                throw new Exception();
            }
        }
        
        public bool CreateSupply(Supply supply)
        {
            try
            {
                _supplyRepository.Add(supply);
                _supplyRepository.SaveDbChange();
                return true;
            }
            catch
            {
                throw new Exception();
            }
        }

        public bool UpdateSupply(UpdateSupplyParameter updateSupplyParameter)
        {
            try
            {
                var supply = _supplyRepository.Get(updateSupplyParameter.Id);
                supply.SellPrice = updateSupplyParameter.SellPrice;
                supply.DiscountPrice = updateSupplyParameter.DiscountPrice;
                supply.Quantity = updateSupplyParameter.Quantity;
                supply.ModifyDate = updateSupplyParameter.ModifyDate;
                supply.ModifyUser = updateSupplyParameter.ModifyUser;
                supply.Status = updateSupplyParameter.Status;

                _supplyRepository.Update(supply);
                _supplyRepository.SaveDbChange();
                return true;
            }
            catch
            {
                throw new Exception();
            }
        }
    }
}
