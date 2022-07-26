using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
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

        public PagedList<Supply> GetSupplysOfCenter(int CenterId, PagingParameter pagingParameter)
        {
            try
            {
                var values =  _supplyRepository.GetAll(x => x.CenterId == CenterId);
                return PagedList<Supply>.ToPagedList(values.AsQueryable(), pagingParameter.PageNumber, pagingParameter.PageSize);
            }
            catch
            {
                throw new Exception();
            }
        }

        public Supply GetSupply(int id)
        {
            return _supplyRepository.Get(id);
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
