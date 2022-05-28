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
    public class OwnerService
    {
        IOwnerRepository _ownerRepository;

        public OwnerService(IOwnerRepository ownerRepository)
        {
            _ownerRepository = ownerRepository;
        }

        //Get All
        public PagedList<Owner> GetModerators(string Name, bool? Status, string dir, string sort, PagingParameter paging)
        {
            var values = _ownerRepository.GetAll(includeProperties: "IdNavigation");

            values = values.Where(x => x.IdNavigation.RoleCode.Trim().Equals("OWN"));

            // lọc theo name
            if (!string.IsNullOrWhiteSpace(Name))
            {
                values = values.Where(x => x.Name.Trim().Equals(Name));
            }

            // lọc theo status
            if (Status != null)
            {
                if (Status == true)
                    values = values.Where(x => x.IdNavigation.Status == true);
                else
                    values = values.Where(x => x.IdNavigation.Status == false);
            }

            if (dir == "asc")
                values = values.OrderBy(d => d.Name);
            else
                values = values.OrderByDescending(d => d.Name);

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
        public int Add(Owner owner)
        {
            try
            {
                _ownerRepository.Add(owner);
                _ownerRepository.SaveDbChange();
                return owner.Id;
            }
            catch
            {
                return -1;
            }
        }

        //Update
        public bool Update(Owner owner)
        {
            try
            {
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
                var objFromDb = _ownerRepository.Get(id);
                if (objFromDb != null)
                {
                    _ownerRepository.Update(objFromDb);
                    _ownerRepository.SaveDbChange();
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
                var objFromDb = _ownerRepository.Get(id);
                if (objFromDb != null)
                {
                    _ownerRepository.Update(objFromDb);
                    _ownerRepository.SaveDbChange();
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