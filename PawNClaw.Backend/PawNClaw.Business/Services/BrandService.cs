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
    public class BrandService
    {
        IBrandRepository _brandRepository;

        public BrandService(IBrandRepository brandRepository)
        {
            _brandRepository = brandRepository;
        }

        //Get All
        public PagedList<Brand> GetAll(string includeProperties, PagingParameter paging)
        {
            var values = _brandRepository.GetAll(includeProperties: includeProperties);

            return PagedList<Brand>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        //Get Id
        public Brand GetById(int id)
        {
            var value = _brandRepository.GetFirstOrDefault(x => x.Id == id);
            return value;
        }

        //Get By Owner Id
        public PagedList<Brand> GetByOwner(int id, PagingParameter paging)
        {
            var values = _brandRepository.GetAll(x => x.OwnerId == id);
            
            return PagedList<Brand>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        //Add
        public int Add(Brand brand)
        {
            try
            {
                if (_brandRepository.GetFirstOrDefault(x => x.Name.Trim().Equals(brand.Name)) != null) 
                    return -1;
                _brandRepository.Add(brand);
                _brandRepository.SaveDbChange();
                return 1;
            }
            catch
            {
                return -1;
            }
        }

        //Update
        public bool Update(Brand brand)
        {
            try
            {
                _brandRepository.Update(brand);
                _brandRepository.SaveDbChange();
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
                var objFromDb = _brandRepository.Get(id);
                objFromDb.Status = false;
                if (objFromDb != null)
                {
                    _brandRepository.Update(objFromDb);
                    _brandRepository.SaveDbChange();
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
                var objFromDb = _brandRepository.Get(id);
                objFromDb.Status = true;
                if (objFromDb != null)
                {
                    _brandRepository.Update(objFromDb);
                    _brandRepository.SaveDbChange();
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
