using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore.Storage;
using PawNClaw.Data.Const;
using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;

namespace PawNClaw.Business.Services
{
    public class OwnerService
    {
        private readonly IAccountRepository _accountRepository;
        private readonly IOwnerRepository _ownerRepository;
        private readonly IPhotoRepository _photoRepository;
        private readonly IBrandRepository _brandRepository;
        private readonly IPetCenterRepository _petCenterRepository;

        private readonly ApplicationDbContext _db;

        public OwnerService(IAccountRepository accountRepository, IOwnerRepository ownerRepository, 
            IPhotoRepository photoRepository, IBrandRepository brandRepository, 
            IPetCenterRepository petCenterRepository, 
            ApplicationDbContext db)
        {
            _accountRepository = accountRepository;
            _ownerRepository = ownerRepository;
            _photoRepository = photoRepository;
            _brandRepository = brandRepository;
            _petCenterRepository = petCenterRepository;
            _db = db;
        }




        //Get All
        public PagedList<Owner> GetOwners(string Name, bool? Status, string dir, string sort, bool? isLookup, PagingParameter paging)
        {
            var values = _ownerRepository.GetAll(includeProperties: "IdNavigation,Brands");

            values = values.Where(x => x.IdNavigation.RoleCode.Trim().Equals("OWN")).Select(x => new Owner() { 
                Name = x.Name,
                Email = x.Email,
                Gender = x.Gender,
                Id = x.Id,
                IdNavigation = new Account()
                {
                    Phone = x.IdNavigation.Phone,
                    UserName = x.IdNavigation.UserName,
                    Status = x.IdNavigation.Status,
                    Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(x.Id, PhotoTypesConst.Account)
                },
                Brands = x.Brands
            });

            // lọc theo name
            if (!string.IsNullOrWhiteSpace(Name)) values = values.Where(x => x.Name.Trim().Contains(Name));

            // lọc theo status
            if (Status != null)
            {
                values = Status == true ? values.Where(x => x.IdNavigation.Status == true) : values.Where(x => x.IdNavigation.Status == false);
            }

            // lọc theo đang sở hữu brand nào hay không
            if (isLookup != null && isLookup == true)
            {
                values = values.Where(x => x.Brands.Count < 1);
            }

            values = dir == "asc" ? values.OrderBy(d => d.Name) : values.OrderByDescending(d => d.Name);

            return PagedList<Owner>.ToPagedList(values.AsQueryable(),
                paging.PageNumber,
                paging.PageSize);
        }

        //Get Id
        public Owner GetOwnerById(int id)
        {
            var value = _ownerRepository.GetAll(includeProperties: "IdNavigation").FirstOrDefault(x => x.Id == id);
            value.IdNavigation.Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(value.Id, PhotoTypesConst.Account);
            return value;
        }

        public Owner GetOwnerByIdForUpdate(int id)
        {
            var value = _ownerRepository.Get(id);
            return value;
        }

        //Add
        public int Add(CreateOwnerParameter owner)
        {
            Owner ownerToDb = new()
            {
                Email = owner.UserName,
                Name = owner.Name,
                Gender = owner.Gender
            };

            Account accountToDb = new()
            {
                UserName = owner.UserName,
                CreatedUser = owner.CreatedUser,
                Phone = owner.Phone,
                RoleCode = owner.RoleCode,
                Status = true
            };

            try
            {
                if (_accountRepository.GetFirstOrDefault(x => x.UserName.Trim().Equals(accountToDb.UserName)) != null)
                    return -1;

                _accountRepository.Add(accountToDb);
                _accountRepository.SaveDbChange();

                ownerToDb.Id = accountToDb.Id;

                _ownerRepository.Add(ownerToDb);
                _ownerRepository.SaveDbChange();
                var id = ownerToDb.Id;
                return id;
            }
            catch
            {
                throw new Exception();
            }
        }

        //Update
        public bool Update(Owner owner, string Phone)
        {
            try
            {
                var account = _accountRepository.Get(owner.Id);
                account.Phone = Phone;
                _accountRepository.Update(account);
                _accountRepository.SaveDbChange();
                _ownerRepository.Update(owner);
                _ownerRepository.SaveDbChange();
                return true;
            }
            catch
            {
                return false;
            }
        }

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
        public async Task<bool> Delete(int id)
        {

            using (IDbContextTransaction transaction = _db.Database.BeginTransaction())
            {
                try
                {

                    var accountFromDb = _accountRepository.Get(id);
                    if (accountFromDb != null)
                    {
                        accountFromDb.Status = false;
                        _accountRepository.Update(accountFromDb);
                        await _accountRepository.SaveDbChangeAsync();
                    }

                    var brandFromDb = _brandRepository.Get(_brandRepository.GetFirstOrDefault(x => x.OwnerId == id).Id);

                    var centers = _petCenterRepository.GetAll(x => x.BrandId == brandFromDb.Id && x.Status == true);

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