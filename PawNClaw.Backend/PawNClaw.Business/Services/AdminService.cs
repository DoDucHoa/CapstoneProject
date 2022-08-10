using PawNClaw.Data.Const;
using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;

namespace PawNClaw.Business.Services
{
    public class AdminService
    {
        private IAdminRepository _adminRepository;
        private IAccountRepository _accountRepository;
        private IPhotoRepository _photoRepository;

        public AdminService(IAdminRepository adminRepository, IAccountRepository accountRepository,
            IPhotoRepository photoRepository)
        {
            _adminRepository = adminRepository;
            _accountRepository = accountRepository;
            _photoRepository = photoRepository;
        }

        //Get All Admin Detail
        public PagedList<Admin> GetAdmins(AdminRequestParameter _requestParameter, bool? Status, PagingParameter paging)
        {
            var values = _adminRepository.GetAll(includeProperties: _requestParameter.includeProperties);

            values = values.Where(x => x.IdNavigation.RoleCode.Trim().Equals("MOD"));

            if (_requestParameter.Id != null)
            {
                values = values.Where(x => x.Id == _requestParameter.Id);
            }
            if (!string.IsNullOrWhiteSpace(_requestParameter.Name))
            {
                values = values.Where(x => x.Name.Trim().Equals(_requestParameter.Name));
            }
            if (!string.IsNullOrEmpty(_requestParameter.Email))
            {
                values = values.Where(x => x.Email.Trim().Equals(_requestParameter.Name));
            }
            if (Status == true)
            {
                values = values.Where(x => x.IdNavigation.Status == true);
            }
            else
            {
                values = values.Where(x => x.IdNavigation.Status == false);
            }

            if (!string.IsNullOrWhiteSpace(_requestParameter.sort))
            {
                switch (_requestParameter.sort)
                {
                    case "Name":
                        if (_requestParameter.dir == "asc")
                            values = values.OrderBy(d => d.Name);
                        else if (_requestParameter.dir == "desc")
                            values = values.OrderByDescending(d => d.Name);
                        break;

                    default:
                        break;
                }
            }

            return PagedList<Admin>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        public PagedList<Admin> GetAdmins(string Name, bool? Status, string dir, string sort, PagingParameter paging)
        {
            var values = _adminRepository.GetAll(includeProperties: "IdNavigation");

            values = values.Where(x => x.IdNavigation.RoleCode.Trim().Equals("MOD"));

            // lọc theo name
            if (!string.IsNullOrWhiteSpace(Name))
            {
                values = values.Where(x => x.Name.Trim().Contains(Name));
            }

            // lọc theo status
            if (Status != null)
            {
                if (Status == true)
                    values = values.Where(x => x.IdNavigation.Status == true);
                else
                    values = values.Where(x => x.IdNavigation.Status == false);
            }

            // sort
            if (!string.IsNullOrWhiteSpace(sort))
            {
                switch (sort)
                {
                    case "Name":
                        if (dir == "asc")
                            values = values.OrderBy(d => d.Name);
                        else if (dir == "desc")
                            values = values.OrderByDescending(d => d.Name);
                        break;

                    case "Id":
                        if (dir == "asc")
                            values = values.OrderBy(d => d.Id);
                        else if (dir == "desc")
                            values = values.OrderByDescending(d => d.Id);
                        break;

                    case "Email":
                        if (dir == "asc")
                            values = values.OrderBy(d => d.Email);
                        else if (dir == "desc")
                            values = values.OrderByDescending(d => d.Email);
                        break;

                    default:
                        break;
                }
            }
            else
            {
                if (dir == "asc")
                    values = values.OrderBy(d => d.Name);
                else if (dir == "desc")
                    values = values.OrderByDescending(d => d.Name);
            }

            return PagedList<Admin>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        //Get Admin by Id
        public Admin GetAdminById(int id)
        {
            var admin = _adminRepository.GetAll(includeProperties: "IdNavigation").FirstOrDefault(x => x.Id == id);

            if (admin == null)
            {
                return admin;
            }

            admin.IdNavigation.Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(id, PhotoTypesConst.Account);
            return admin;
        }

        //Add Admin
        public int Add(CreateAdminParameter admin)
        {
            Admin adminToDB = new Admin
            {
                Email = admin.UserName,
                Name = admin.Name,
                Gender = admin.Gender
            };

            Account accountToDb = new Account
            {
                UserName = admin.UserName,
                CreatedUser = admin.CreatedUser,
                Phone = admin.Phone,
                RoleCode = admin.RoleCode,
                Status = true
            };
            try
            {
                if (_accountRepository.GetFirstOrDefault(x => x.UserName.Trim().Equals(accountToDb.UserName)) != null)
                    return -1;
                _accountRepository.Add(accountToDb);
                _accountRepository.SaveDbChange();

                adminToDB.Id = accountToDb.Id;

                _adminRepository.Add(adminToDB);
                _adminRepository.SaveDbChange();
                var id = adminToDB.Id;
                return id;
            }
            catch
            {
                throw new Exception();
            }
        }

        //Update Admin
        public bool Update(Admin admin, string Phone)
        {
            try
            {
                Account account = _accountRepository.Get(admin.Id);
                account.Phone = Phone;
                _accountRepository.Update(account);
                _accountRepository.SaveDbChange();
                _adminRepository.Update(admin);
                _adminRepository.SaveDbChange();
                return true;
            }
            catch
            {
                return false;
            }
        }

        public bool Update(Admin admin)
        {
            try
            {
                _adminRepository.Update(admin);
                _adminRepository.SaveDbChange();
                return true;
            }
            catch
            {
                return false;
            }
        }

        //Delete Admin
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

        //Restore Admin
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