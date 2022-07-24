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
            return _dbSet.Include(x => x.Owner).ThenInclude(y => y.IdNavigation).FirstOrDefault(brand => brand.Id == id);
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
    }
}
