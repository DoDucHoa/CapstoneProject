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
    public class PetCenterService
    {
        IPetCenterRepository _petCenterRepository;

        public PetCenterService(IPetCenterRepository petCenterRepository)
        {
            _petCenterRepository = petCenterRepository;
        }

        //Get All
        public PagedList<PetCenter> GetAll(string includeProperties, PagingParameter paging)
        {
            var values = _petCenterRepository.GetAll(includeProperties: includeProperties);

            return PagedList<PetCenter>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        //Get Id
        public PetCenter GetById(int id)
        {
            var value = _petCenterRepository.GetFirstOrDefault(x => x.Id == id);
            return value;
        }

        //Get By Brand Id
        public PagedList<PetCenter> GetByOwner(int id, PagingParameter paging)
        {
            var values = _petCenterRepository.GetAll(x => x.BrandId == id);

            return PagedList<PetCenter>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        //Add
        public int Add(PetCenter petCenter)
        {
            try
            {
                if (_petCenterRepository.GetFirstOrDefault(x => x.Name.Trim().Equals(petCenter.Name)) != null)
                    return -1;
                if (_petCenterRepository.GetFirstOrDefault(x => x.Address.Trim().Equals(petCenter.Address)) != null)
                    return -1;
                _petCenterRepository.Add(petCenter);
                _petCenterRepository.SaveDbChange();
                return 1;
            }
            catch
            {
                return -1;
            }
        }

        //Update
        public bool Update(PetCenter petCenter)
        {
            try
            {
                _petCenterRepository.Update(petCenter);
                _petCenterRepository.SaveDbChange();
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
                var objFromDb = _petCenterRepository.Get(id);
                objFromDb.Status = false;
                if (objFromDb != null)
                {
                    _petCenterRepository.Update(objFromDb);
                    _petCenterRepository.SaveDbChange();
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
                var objFromDb = _petCenterRepository.Get(id);
                objFromDb.Status = true;
                if (objFromDb != null)
                {
                    _petCenterRepository.Update(objFromDb);
                    _petCenterRepository.SaveDbChange();
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
