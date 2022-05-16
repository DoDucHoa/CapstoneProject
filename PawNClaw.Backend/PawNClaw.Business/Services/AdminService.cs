﻿using PawNClaw.Data.Database;
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
    public class AdminService
    {
        IAdminRepository _adminRepository;
        IAccountRepository _accountRepository;

        public AdminService(IAdminRepository adminRepository, IAccountRepository accountRepository)
        {
            _adminRepository = adminRepository;
            _accountRepository = accountRepository;
        }

        //Get All Admin Detail
        public PagedList<Admin> GetAdmins(AdminRequestParameter _requestParameter, PagingParameter paging)
        {
            var values = _adminRepository.GetAll(includeProperties: _requestParameter.includeProperties);

            values = values.Where(x => x.IdNavigation.RoleCode.Trim().EndsWith("MOD"));

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
            if (_requestParameter.Status == true)
            {
                values = values.Where(x => x.Status == true);
            }
            else if (_requestParameter.Status == false)
            {
                values = values.Where(x => x.Status == false);
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

            

            if (!string.IsNullOrWhiteSpace(Name))
            {
                values = values.Where(x => x.Name.Trim().Equals(Name));
            }
            if (Status == true)
            {
                values = values.Where(x => x.Status == true);
            }
            else if (Status == false)
            {
                values = values.Where(x => x.Status == false);
            }

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
                }
            } else
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
            return _adminRepository.GetAll().FirstOrDefault(x => x.Id == id);
        }

        //Add Admin
        public int Add(CreateAdminParameter admin)
        {
            Admin adminToDB = new Admin
            {
                Email = admin.UserName,
                Name = admin.Name,
                Status = true
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
                return -1;
            }
        }

        //Update Admin  
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
                var objFromDb = _adminRepository.Get(id);
                objFromDb.Status = false;
                var accountFromDb = _accountRepository.Get(objFromDb.Id);
                accountFromDb.Status = false;
                if (objFromDb != null)
                {
                    _adminRepository.Update(objFromDb);
                    _adminRepository.SaveDbChange();
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
                var objFromDb = _adminRepository.Get(id);
                objFromDb.Status = true;
                var accountFromDb = _accountRepository.Get(objFromDb.Id);
                accountFromDb.Status = true;
                if (objFromDb != null)
                {
                    _adminRepository.Update(objFromDb);
                    _adminRepository.SaveDbChange();
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
