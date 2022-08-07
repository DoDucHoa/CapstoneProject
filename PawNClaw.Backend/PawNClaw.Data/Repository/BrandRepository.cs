using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Helper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using PawNClaw.Data.Const;

namespace PawNClaw.Data.Repository
{
    public class BrandRepository : Repository<Brand>, IBrandRepository
    {
        IPhotoRepository _photoRepository;

        public BrandRepository(ApplicationDbContext db, IPhotoRepository photoRepository) : base(db)
        {
            _photoRepository = photoRepository;
        }

        public Brand GetBrandById(int id)
        {
            return _dbSet
                .Where(brand => brand.Id == id)
                .Select(x => new Brand
                {
                    Id = x.Id,
                    Name = x.Name,
                    Description = x.Description,
                    Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(x.Id, PhotoTypesConst.Brand),
                    Owner = new Owner()
                    {
                        Id = x.Owner.Id,
                        Email = x.Owner.Email,
                        Gender = x.Owner.Gender,
                        Name = x.Owner.Name,
                        IdNavigation = x.Owner.IdNavigation
                    },
                    CreateDate = x.CreateDate,
                    CreateUser = x.CreateUser,
                    ModifyDate = x.ModifyDate,
                    ModifyUser = x.ModifyUser,
                    Status = x.Status,
                    SponsorBanners = x.SponsorBanners,
                    PetCenters = (ICollection<PetCenter>)x.PetCenters
                    .Select(center => new PetCenter
                    {
                        Id = center.Id,
                        Name = center.Name,
                        Address = center.Address,
                        Phone = center.Phone,
                        Rating = center.Rating,
                        CreateDate = center.CreateDate,
                        Status = center.Status,
                        OpenTime = center.OpenTime,
                        CloseTime = center.CloseTime,
                        Description = center.Description,
                        BrandId = center.BrandId,
                        Checkin = center.Checkin,
                        Checkout = center.Checkout,
                        Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(center.Id, PhotoTypesConst.PetCenter)
                    }),
                })
                .FirstOrDefault();
        }

        public Brand GetBrandByOwner(int OwnerId)
        {
            return _dbSet.Include(x => x.PetCenters)
                .Where(brand => brand.OwnerId == OwnerId)
                .Select(x => new Brand {
                    Id = x.Id,
                    Name = x.Name,
                    Description = x.Description,
                    PetCenters = (ICollection<PetCenter>)x.PetCenters
                    .Select(center => new PetCenter
                    {
                        Id = center.Id,
                        Name = center.Name,
                        Address = center.Address,
                        Phone = center.Phone,
                        Rating = center.Rating,
                        CreateDate = center.CreateDate,
                        Status = center.Status,
                        OpenTime = center.OpenTime,
                        CloseTime = center.CloseTime,
                        Description = center.Description,
                        BrandId = center.BrandId,
                        Checkin = center.Checkin,
                        Checkout = center.Checkout,
                        Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(center.Id, PhotoTypesConst.PetCenter)
                    }),
                    Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(x.Id, PhotoTypesConst.Brand)
                })
                .FirstOrDefault();
        }

        public IEnumerable<Brand> GetBrands()
        {
            return _dbSet
                .Select(x => new Brand
                {
                    Id = x.Id,
                    Name = x.Name,
                    Description = x.Description,
                    Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(x.Id, PhotoTypesConst.Brand),
                    Owner = new Owner()
                    {
                        Id = x.Owner.Id,
                        Email = x.Owner.Email,
                        Gender = x.Owner.Gender,
                        Name = x.Owner.Name,
                        IdNavigation = x.Owner.IdNavigation
                    },
                    CreateDate = x.CreateDate,
                    CreateUser = x.CreateUser,
                    ModifyDate = x.ModifyDate,
                    ModifyUser = x.ModifyUser,
                    Status = x.Status,
                    SponsorBanners = x.SponsorBanners,
                    PetCenters = (ICollection<PetCenter>)x.PetCenters
                    .Select(center => new PetCenter
                    {
                        Id = center.Id,
                        Name = center.Name,
                        Address = center.Address,
                        Phone = center.Phone,
                        Rating = center.Rating,
                        CreateDate = center.CreateDate,
                        Status = center.Status,
                        OpenTime = center.OpenTime,
                        CloseTime = center.CloseTime,
                        Description = center.Description,
                        BrandId = center.BrandId,
                        Checkin = center.Checkin,
                        Checkout = center.Checkout,
                        Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(center.Id, PhotoTypesConst.PetCenter)
                    }),
                }).ToList();
        }
    }
}
