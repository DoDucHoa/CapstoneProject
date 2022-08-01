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


        public bool CreateVouchers(CreateVoucherParameter voucherP)
        {
            Voucher voucher = new Voucher()
            {
                Code = voucherP.Code,
                MinCondition = voucherP.MinCondition,
                Value = voucherP.Value,
                StartDate = voucherP.StartDate,
                ExpireDate = voucherP.ExpireDate,
                CreateDate = voucherP.CreateDate,
                ModifyDate = voucherP.ModifyDate,
                CreateUser = voucherP.CreateUser,
                ModifyUser = voucherP.ModifyUser,
                Status = true,
                CenterId = voucherP.CenterId,
                VoucherTypeCode = voucherP.VoucherTypeCode,
            };

            _voucherRepository.Add(voucher);
            _voucherRepository.SaveDbChange();
            return true;
        }

        public bool UpdateVoucher(UpdateVoucherParameter voucherP)
        {
            Voucher voucher = _voucherRepository.Get(voucherP.Code);
            voucher.MinCondition = voucherP.MinCondition;
            voucher.Value = voucherP.Value;
            voucher.StartDate = voucherP.StartDate;
            voucher.ExpireDate = voucherP.ExpireDate;
            voucher.ModifyDate = voucherP.ModifyDate;
            voucher.ModifyUser = voucherP.ModifyUser;
            voucher.Status = voucherP.Status;

            _voucherRepository.Update(voucher);
            _voucherRepository.SaveDbChange();
            return true;
        }

        public bool UpdateStatus(string code)
        {
            Voucher voucher = _voucherRepository.Get(code);

            bool status = (bool)!voucher.Status;

            voucher.Status = status;

            _voucherRepository.Update(voucher);
            _voucherRepository.SaveDbChange();

            return true;
        }
    }
}
