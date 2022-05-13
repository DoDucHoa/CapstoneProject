using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class StaffServicecs
    {
        IStaffRepository _staffRepository;

        public StaffServicecs(IStaffRepository staffRepository)
        {
            _staffRepository = staffRepository;
        }

        //Get All
        public PagedList<Staff> GetAll(int id, string includeProperties, PagingParameter paging)
        {
            var values = _staffRepository.GetAll(includeProperties: includeProperties);

            if (id > 0)
            {
                values = values.Where(x => x.Id == id);
            }

            return PagedList<Staff>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        //Get Id
        public Staff GetById(int id)
        {
            var value = _staffRepository.GetFirstOrDefault(x => x.Id == id);

            return value;
        }

        //Get Staff By Center Id
        public PagedList<Staff> GetByCenterId(int id, PagingParameter paging)
        {
            var values = _staffRepository.GetAll(x => x.CenterId == id);
            return PagedList<Staff>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        //Add
        public int Add(Staff staff)
        {
            try
            {
                _staffRepository.Add(staff);
                _staffRepository.SaveDbChange();
                return 1;
            }
            catch
            {
                return -1;
            }
        }

        //Update
        public bool Update(Staff staff)
        {
            try
            {
                _staffRepository.Update(staff);
                _staffRepository.SaveDbChange();
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
                var objFromDb = _staffRepository.Get(id);
                objFromDb.Status = false;
                if (objFromDb != null)
                {
                    _staffRepository.Update(objFromDb);
                    _staffRepository.SaveDbChange();
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
                var objFromDb = _staffRepository.Get(id);
                objFromDb.Status = true;
                if (objFromDb != null)
                {
                    _staffRepository.Update(objFromDb);
                    _staffRepository.SaveDbChange();
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
