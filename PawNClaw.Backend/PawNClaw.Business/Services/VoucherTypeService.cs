using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class VoucherTypeService
    {
        IVoucherTypeRepository _voucherTypeRepository;

        public VoucherTypeService(IVoucherTypeRepository voucherTypeRepository)
        {
            _voucherTypeRepository = voucherTypeRepository;
        }

        public IEnumerable<VoucherType> GetAll()
        {
            return _voucherTypeRepository.GetAll();
        }
    }
}
