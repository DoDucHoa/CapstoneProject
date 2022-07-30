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
    public class ServiceRepository : Repository<Service>, IServiceRepository
    {
        IPhotoRepository _photoRepository;

        public ServiceRepository(ApplicationDbContext db, IPhotoRepository photoRepository) : base(db)
        {
            _photoRepository = photoRepository;
        }

        public IEnumerable<Service> GetServicesOfCenter(int centerId)
        {
            IQueryable<Service> query = _dbSet;

            query = query
                .Include(x => x.ServicePrices)
                .Select(x => new Service {
                    Id = x.Id,
                    Description = x.Description,
                    DiscountPrice = x.DiscountPrice,
                    CreateDate = x.CreateDate,
                    CreateUser = x.CreateUser,
                    ModifyDate = x.ModifyDate,
                    ModifyUser = x.ModifyUser,
                    Status = x.Status,
                    CenterId = x.CenterId,
                    Name = x.Name,
                    ServicePrices = x.ServicePrices,
                    Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(x.Id, PhotoTypesConst.Service),
                })
                .Where(x => x.CenterId == centerId);

            return query.ToList();
        }
    }
}
