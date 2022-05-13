using PawNClaw.Data.Database;
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

        public AdminService(IAdminRepository adminRepository)
        {
            _adminRepository = adminRepository;
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

        public PagedList<Admin> GetAdmins(string Name, bool? Status, PagingParameter paging)
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

            

            values = values.OrderBy(d => d.Name);

            

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
        public int Add(Admin admin)
        {
            try
            {
                _adminRepository.Add(admin);
                _adminRepository.SaveDbChange();
                var id = admin.Id;
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
                if (objFromDb != null)
                {
                    _adminRepository.Update(objFromDb);
                    _adminRepository.SaveDbChange();
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
                if (objFromDb != null)
                {
                    _adminRepository.Update(objFromDb);
                    _adminRepository.SaveDbChange();
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
