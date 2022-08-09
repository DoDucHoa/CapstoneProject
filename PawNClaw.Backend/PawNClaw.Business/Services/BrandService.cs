using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System;
using System.Linq;

namespace PawNClaw.Business.Services
{
    public class BrandService
    {
        private readonly IBrandRepository _brandRepository;

        public BrandService(IBrandRepository brandRepository)
        {
            _brandRepository = brandRepository;
        }

        //Get All
        public PagedList<Brand> GetBrands(string name, bool? status, string dir, PagingParameter paging)
        {
            var values = _brandRepository.GetBrands();

            // lọc theo name
            if (!string.IsNullOrWhiteSpace(name))
            {
                values = values.Where(brand => brand.Name.Trim().Equals(name));
            }

            // lọc theo status
            if (status != null)
            {
                values = status == true ? values.Where(brand => brand.Status == true) : values.Where(brand => brand.Status == false);
            }

            values = dir == "asc" ? values.OrderBy(brand => brand.Name) : values.OrderByDescending(brand => brand.Name);

            return PagedList<Brand>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        //Get Id
        public Brand GetBrandById(int id)
        {
            var value = _brandRepository.GetBrandById(id);
            return value;
        }

        public Brand GetBrandByIdForUpdate(int id)
        {
            var value = _brandRepository.Get(id);
            return value;
        }

        //Get By Owner Id
        public Brand GetBrandByOwnerId(int OwnerId)
        {
            var values = _brandRepository.GetBrandByOwner(OwnerId);
            return values;
        }

        //Add
        public int Add(CreateBrandParameter brand)
        {
            Brand brandToDb = new()
            {
                Name = brand.Name,
                Description = brand.Description,
                OwnerId = brand.OwnerId,
                CreateUser = brand.CreateUser,
                ModifyUser = brand.ModifyUser
            };

            try
            {
                _brandRepository.Add(brandToDb);
                _brandRepository.SaveDbChange();
                var id = brandToDb.Id;
                return id;
            }
            catch (Exception ex)
            {
                Console.WriteLine("This is error: " + ex.Message);
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
                var brandFromDb = _brandRepository.Get(id);
                if (brandFromDb != null)
                {
                    brandFromDb.Status = false;
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
                var brandFromDb = _brandRepository.Get(id);
                if (brandFromDb != null)
                {
                    brandFromDb.Status = true;
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