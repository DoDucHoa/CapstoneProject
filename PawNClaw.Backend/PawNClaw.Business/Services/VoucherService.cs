using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class VoucherService
    {
        IVoucherRepository _voucherRepository;

        public VoucherService(IVoucherRepository voucherRepository)
        {
            _voucherRepository = voucherRepository;
        }

        public IEnumerable<Voucher> GetVouchersIsAvaliable(int centerId)
        {
            return _voucherRepository.GetAll(x => x.CenterId == centerId && x.Status == true);
        }

        public IEnumerable<Voucher> GetVouchers(int centerId)
        {
            return _voucherRepository.GetAll(x => x.CenterId == centerId);
        }

        public Voucher GetVoucher(string code)
        {
            return _voucherRepository.Get(code);
        }


        public bool CreateVouchers(Voucher voucher)
        {
            _voucherRepository.Add(voucher);
            _voucherRepository.SaveDbChange();
            return true;
        }

        public bool UpdateVoucher(Voucher voucher)
        {
            _voucherRepository.Update(voucher);
            _voucherRepository.SaveDbChange();
            return true;
        }
    }
}
