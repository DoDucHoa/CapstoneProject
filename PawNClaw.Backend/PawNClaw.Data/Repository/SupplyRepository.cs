using Microsoft.EntityFrameworkCore;
using PawNClaw.Data.Const;
using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class SupplyRepository : Repository<Supply>, ISupplyRepository
    {
        private ApplicationDbContext _db;
        IPhotoRepository _photoRepository;

        public SupplyRepository(ApplicationDbContext db, IPhotoRepository photoRepository) : base(db)
        {
            _db = db;
            _photoRepository = photoRepository;
        }

        public IEnumerable<Supply> GetSuppliesWithType(int centerId)
        {
            IQueryable<Supply> query = _dbSet;

            var values = query.Include(x => x.SupplyTypeCodeNavigation)
                .Select(x => new Supply
                {
                    Id = x.Id,
                    Name = x.Name,
                    SellPrice = x.SellPrice,
                    DiscountPrice = x.DiscountPrice,
                    Quantity = x.Quantity,
                    CreateDate = x.CreateDate,
                    ModifyDate = x.ModifyDate,
                    CreateUser = x.CreateUser,
                    ModifyUser = x.ModifyUser,
                    Status = x.Status,
                    CenterId = x.CenterId,
                    SupplyTypeCode = x.SupplyTypeCode,
                    Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(x.Id, PhotoTypesConst.Supply),
                    SupplyTypeCodeNavigation = x.SupplyTypeCodeNavigation
                })
                .Where(x => x.CenterId == centerId);

            return values;
        }

        public Supply GetSupplyById(int id)
        {
            Supply query = _dbSet
                .Select(x => new Supply
                {
                    Id = x.Id,
                    Name = x.Name,
                    SellPrice = x.SellPrice,
                    DiscountPrice = x.DiscountPrice,
                    Quantity = x.Quantity,
                    CreateDate = x.CreateDate,
                    ModifyDate = x.ModifyDate,
                    CreateUser = x.CreateUser,
                    ModifyUser = x.ModifyUser,
                    Status = x.Status,
                    CenterId = x.CenterId,
                    SupplyTypeCode = x.SupplyTypeCode,
                    Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(x.Id, PhotoTypesConst.Supply),
                    SupplyTypeCodeNavigation = x.SupplyTypeCodeNavigation
                })
                .First(x => x.Id == id);

            return query;
        }
    }
}
