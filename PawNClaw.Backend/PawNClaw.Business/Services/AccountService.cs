using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System.Linq;

namespace PawNClaw.Business.Services
{
    public class AccountService
    {
        IAccountRepository _accountRepository;
        public AccountService(IAccountRepository accountRepository)
        {
            _accountRepository = accountRepository;
        }

        //Get All Account Detail
        public PagedList<Account> GetAccounts(AccountRequestParameter _requestParameter, PagingParameter paging)
        {
            var values = _accountRepository.GetAll(includeProperties: _requestParameter.includeProperties);

            if (_requestParameter.Id != null)
            {
                values = values.Where(x => x.Id == _requestParameter.Id);
            }
            if (!string.IsNullOrWhiteSpace(_requestParameter.UserName))
            {
                values = values.Where(x => x.UserName.Trim().Equals(_requestParameter.UserName));
            }
            if (_requestParameter.CreatedUser != null)
            {
                values = values.Where(x => x.CreatedUser == _requestParameter.CreatedUser);
            }
            if (_requestParameter.RoleCode != null)
            {
                values = values.Where(x => x.RoleCode.Trim().Equals(_requestParameter.RoleCode));
            }
            if (_requestParameter.Phone != null)
            {
                values = values.Where(x => x.Phone.Trim().Equals(_requestParameter.Phone));
            }

            values = _requestParameter.Status switch
            {
                true => values.Where(x => x.Status == true),
                false => values.Where(x => x.Status == false),
                _ => values
            };

            if (!string.IsNullOrWhiteSpace(_requestParameter.sort))
            {
                switch (_requestParameter.sort)
                {
                    case "UserName":
                        if (_requestParameter.dir == "asc")
                            values = values.OrderBy(d => d.Id);
                        else if (_requestParameter.dir == "desc")
                            values = values.OrderByDescending(d => d.Id);
                        break;
                }
            }

            return PagedList<Account>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        //Get Account by Id  
        public Account GetAccountById(int id)
        {
            return _accountRepository.GetAccountWithInFor(id);
        }

        //Add Account
        public int Add(Account account)
        {
            try
            {
                if (_accountRepository.GetFirstOrDefault(x => x.UserName.Trim().Equals(account.UserName)) != null)
                    return -1;
                _accountRepository.Add(account);
                _accountRepository.SaveDbChange();
                var id = account.Id;
                return id;
            }
            catch
            {
                return -1;
            }
        }

        //Update Account  
        public bool Update(Account account)
        {
            try
            {
                _accountRepository.Update(account);
                _accountRepository.SaveDbChange();
                return true;
            }
            catch
            {
                return false;
            }
        }

        //Delete Account
        public bool Delete(int id)
        {
            try
            {
                var objFromDb = _accountRepository.Get(id);
                objFromDb.Status = false;
                if (objFromDb != null)
                {
                    _accountRepository.Update(objFromDb);
                    _accountRepository.SaveDbChange();
                    return true;
                }
            }
            catch
            {
                return false;
            }
            return false;
        }

        //Restore Account
        public bool Restore(int id)
        {
            try
            {
                var objFromDb = _accountRepository.Get(id);
                objFromDb.Status = true;
                if (objFromDb != null)
                {
                    _accountRepository.Update(objFromDb);
                    _accountRepository.SaveDbChange();
                    return true;
                }
            }
            catch
            {
                return false;
            }
            return false;
        }
    }
}
