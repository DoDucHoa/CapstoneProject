using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class AdminDashboardService
    {
        IPetCenterRepository _petCenterRepository;
        IBrandRepository _brandRepository;
        IAccountRepository _accountRepository;

        public AdminDashboardService(IPetCenterRepository petCenterRepository, IBrandRepository brandRepository,
            IAccountRepository accountRepository)
        {
            _petCenterRepository = petCenterRepository;
            _brandRepository = brandRepository;
            _accountRepository = accountRepository;
        }

        public int CenterAvailable()
        {
            return _petCenterRepository.GetAll(x => x.Status == true).Count();
        }

        public int BrandAvailable()
        {
            return _brandRepository.GetAll(x => x.Status == true).Count();
        }

        public int CustomerAvailable()
        {
            return _accountRepository.GetAll(includeProperties: "Customer", filter: x => x.Status == true).Where(x => x.Customer != null).Count();
        }
    }
}
