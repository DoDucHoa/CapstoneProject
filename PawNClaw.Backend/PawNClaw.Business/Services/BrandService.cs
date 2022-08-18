using Microsoft.EntityFrameworkCore.Storage;
using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class BrandService
    {
        private readonly IBrandRepository _brandRepository;
        private readonly IPetCenterRepository _petCenterRepository;

        private readonly ApplicationDbContext _db;

        public BrandService(IBrandRepository brandRepository, IPetCenterRepository petCenterRepository,
            ApplicationDbContext db)
        {
            _brandRepository = brandRepository;
            _petCenterRepository = petCenterRepository;
            _db = db;
        }

        //Get All
        public PagedList<Brand> GetBrands(string name, bool? status, string dir, PagingParameter paging)
        {
            var values = _brandRepository.GetBrands();

            // lọc theo name
            if (!string.IsNullOrWhiteSpace(name))
            {
                values = values.Where(brand => brand.Name.Trim().Contains(name));
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

            if (_brandRepository.GetAll(x => x.Name.ToLower().Equals(brand.Name.ToLower())).Count() > 0)
            {
                throw new Exception("Name is existed");
            }

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
            catch
            {
                throw new Exception("Bad Request");
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
        public async Task<bool> Delete(int id)
        {
            using (IDbContextTransaction transaction = _db.Database.BeginTransaction())
            {
                try
                {
                    var brandFromDb = _brandRepository.Get(id);

                    var centers = _petCenterRepository.GetAll(x => x.BrandId == id && x.Status == true);

                    foreach (var item in centers)
                    {
                        var center = _petCenterRepository.Get(item.Id);
                        center.Status = false;

                        _petCenterRepository.Update(center);
                        await _petCenterRepository.SaveDbChangeAsync();
                    }

                    if (brandFromDb != null)
                    {
                        brandFromDb.Status = false;
                        await _brandRepository.SaveDbChangeAsync();
                        transaction.Commit();
                        return true;
                    }
                }
                catch
                {
                    transaction.Rollback();
                    throw new Exception();
                }
                transaction.Rollback();
                return false;
            }
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