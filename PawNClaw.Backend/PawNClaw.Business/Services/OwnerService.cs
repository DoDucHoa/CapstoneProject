using System;
using System.Linq;
using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;

namespace PawNClaw.Business.Services
{
    public class OwnerService
    {
        private readonly IAccountRepository _accountRepository;
        private readonly IOwnerRepository _ownerRepository;

        public OwnerService(IOwnerRepository ownerRepository, IAccountRepository accountRepository)
        {
            _ownerRepository = ownerRepository;
            _accountRepository = accountRepository;
        }

        //Get All
        public PagedList<Owner> GetModerators(string Name, bool? Status, string dir, string sort, PagingParameter paging)
        {
            var values = _ownerRepository.GetAll(includeProperties: "IdNavigation");

            values = values.Where(x => x.IdNavigation.RoleCode.Trim().Equals("OWN"));

            // lọc theo name
            if (!string.IsNullOrWhiteSpace(Name)) values = values.Where(x => x.Name.Trim().Equals(Name));

            // lọc theo status
            if (Status != null)
            {
                values = Status == true ? values.Where(x => x.IdNavigation.Status == true) : values.Where(x => x.IdNavigation.Status == false);
            }

            values = dir == "asc" ? values.OrderBy(d => d.Name) : values.OrderByDescending(d => d.Name);

            return PagedList<Owner>.ToPagedList(values.AsQueryable(),
                paging.PageNumber,
                paging.PageSize);
        }

        //Get Id
        public Owner GetOwnerById(int id)
        {
            var value = _ownerRepository.GetFirstOrDefault(x => x.Id == id);
            return value;
        }

        //Add
        public int Add(CreateOwnerParameter owner)
        {
            Owner ownerToDb = new()
            {
                Email = owner.UserName,
                Name = owner.Name
                //Gender = owner.Gender
            };

            Account accountToDb = new()
            {
                UserName = owner.UserName,
                CreatedUser = owner.CreatedUser,
                Phone = owner.Phone,
                RoleCode = owner.RoleCode,
                Status = true
            };

            try
            {
                if (_accountRepository.GetFirstOrDefault(x => x.UserName.Trim().Equals(accountToDb.UserName)) != null)
                    return -1;

                _accountRepository.Add(accountToDb);
                _accountRepository.SaveDbChange();

                ownerToDb.Id = accountToDb.Id;

                _ownerRepository.Add(ownerToDb);
                _ownerRepository.SaveDbChange();
                var id = ownerToDb.Id;
                return id;
            }
            catch (Exception ex)
            {
                Console.WriteLine("This is error: " + ex.Message);
                return -1;
            }
        }

        //Update
        public bool Update(Owner owner, string Phone)
        {
            try
            {
                var account = _accountRepository.Get(owner.Id);
                account.Phone = Phone;
                _accountRepository.Update(account);
                _accountRepository.SaveDbChange();
                _ownerRepository.Update(owner);
                _ownerRepository.SaveDbChange();
                return true;
            }
            catch
            {
                return false;
            }
        }

        //Delete
        public bool Delete(int id)
        {
            try
            {
                var accountFromDb = _accountRepository.Get(id);
                if (accountFromDb != null)
                {
                    accountFromDb.Status = false;
                    _accountRepository.Update(accountFromDb);
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

        //Restore
        public bool Restore(int id)
        {
            try
            {
                var accountFromDb = _accountRepository.Get(id);
                if (accountFromDb != null)
                {
                    accountFromDb.Status = true;
                    _accountRepository.Update(accountFromDb);
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