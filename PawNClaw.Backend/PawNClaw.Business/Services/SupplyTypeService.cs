using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class SupplyTypeService
    {
        ISupplyTypeRepository _supplyTypeRepository;

        public SupplyTypeService(ISupplyTypeRepository supplyTypeRepository)
        {
            _supplyTypeRepository = supplyTypeRepository;
        }

        public IEnumerable<SupplyType> GetSupplyType()
        {
            try
            {
                return _supplyTypeRepository.GetAll();
            }
            catch
            {
                throw new Exception();
            }
        }
    }
}
