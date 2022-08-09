using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class CustomerService
    {
        ICustomerRepository _customerRepository;

        public CustomerService(ICustomerRepository customerRepository)
        {
            _customerRepository = customerRepository;
        }

        public bool Update(Customer customer)
        {
            _customerRepository.Update(customer);
            _customerRepository.SaveDbChange();
            return true;
        }

        public void UpdateStatus(int id)
        {
            try
            {
                var cus = _customerRepository.GetFirstOrDefault(x => x.Id == id, includeProperties: "IdNavigation");
                switch (cus.IdNavigation.Status)
                {
                    case true:
                        cus.IdNavigation.Status = false;
                        break;
                    default:
                        cus.IdNavigation.Status = false;
                        break;
                }
                _customerRepository.Update(cus);
                _customerRepository.SaveDbChange();
            }
            catch
            {
                throw new Exception();
            }
        }

    }
}
