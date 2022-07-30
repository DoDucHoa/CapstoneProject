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

        public PagedList<Supply> GetSupplysOfCenter(SupplyRequestParameter supplyRequestParameter, PagingParameter pagingParameter)
        {
            try
            {
                var values = _supplyRepository.GetSuppliesWithType(supplyRequestParameter.CenterId);

                if(!string.IsNullOrWhiteSpace(supplyRequestParameter.TypeCode))
                {
                    values = values.Where(x => x.SupplyTypeCode.ToLower().Equals(supplyRequestParameter.TypeCode.ToLower().Trim()));
                }

                if (!string.IsNullOrWhiteSpace(supplyRequestParameter.Name))
                {
                    values = values.Where(x => x.Name.ToLower().Equals(supplyRequestParameter.Name.ToLower().Trim()));
                }

                if (supplyRequestParameter.Status != null)
                {
                    values = supplyRequestParameter.Status switch
                    {
                        true => values.Where(x => x.Status == true),
                        false => values.Where(x => x.Status == false),
                        _ => values
                    };
                }

                if (!string.IsNullOrWhiteSpace(supplyRequestParameter.sort))
                {
                    switch (supplyRequestParameter.sort)
                    {
                        case "name":
                            if (supplyRequestParameter.dir == "asc")
                                values = values.OrderBy(d => d.Name);
                            else if (supplyRequestParameter.dir == "desc")
                                values = values.OrderByDescending(d => d.Name);
                            break;
                    }
                }

                return PagedList<Supply>.ToPagedList(values.AsQueryable(), pagingParameter.PageNumber, pagingParameter.PageSize);
            }
            catch
            {
                throw new Exception();
            }
        }

        public Supply GetSupply(int id)
        {
            return _supplyRepository.GetSupplyById(id);
        }
        
        public int CreateSupply(CreateSupplyParameter supplyP)
        {
            try
            {
                Supply supply = new Supply()
                {
                    Name = supplyP.Name,
                    SellPrice = supplyP.SellPrice,
                    DiscountPrice = supplyP.DiscountPrice,
                    Quantity = supplyP.Quantity,
                    CreateDate = supplyP.CreateDate,
                    ModifyDate = supplyP.ModifyDate,
                    CreateUser = supplyP.CreateUser,
                    ModifyUser = supplyP.ModifyUser,
                    Status = true,
                    SupplyTypeCode = supplyP.SupplyTypeCode,
                    CenterId = supplyP.CenterId
                };

                _supplyRepository.Add(supply);
                _supplyRepository.SaveDbChange();
                return supply.Id;
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
