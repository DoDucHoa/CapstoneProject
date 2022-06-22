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
        private IBrandRepository _brandRepository;

        public BrandService(IBrandRepository brandRepository)
        {
            _brandRepository = brandRepository;
        }

        //Get All
        public PagedList<Brand> GetBrands(string Name, bool? Status, string dir, PagingParameter paging)
        {
            var values = _brandRepository.GetAll(includeProperties: "Owner");

            // lọc theo name
            if (!string.IsNullOrWhiteSpace(Name))
            {
                values = values.Where(x => x.Name.Trim().Equals(Name));
            }

            // lọc theo status
            if (Status != null)
            {
                if (Status == true)
                    values = values.Where(x => x.Status == true);
                else
                    values = values.Where(x => x.Status == false);
            }

            if (dir == "asc")
                values = values.OrderBy(d => d.Name);
            else
                values = values.OrderByDescending(d => d.Name);

            return PagedList<Brand>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        //Get Id
        public Brand GetBrandById(int id)
        {
            var value = _brandRepository.GetFirstOrDefault(x => x.Id == id);
            return value;
        }

        //Add
        public int Add(CreateBrandParameter brand)
        {
            Brand brandToDB = new()
            {
                Name = brand.Name,
                Description = brand.Description,
                OwnerId = brand.OwnerId,
                CreateUser = brand.CreateUser,
                ModifyUser = brand.ModifyUser
            };

            try
            {
                _brandRepository.Add(brandToDB);
                _brandRepository.SaveDbChange();
                var id = brandToDB.Id;
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