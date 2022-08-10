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
    public class ServiceOrderRepository : Repository<ServiceOrder>, IServiceOrderRepository
    {
        IPhotoRepository _photoRepository;
        public ServiceOrderRepository(ApplicationDbContext db, IPhotoRepository photoRepository) : base(db)
        {
            _photoRepository = photoRepository;
        }

        public void RemoveServiceOrder(int BookingId, int ServiceId)
        {
            _dbSet.Remove(_dbSet.Find(ServiceId, BookingId));
        }

        public IEnumerable<ServiceOrder> GetServiceOrdersByPetIdAndBookingId(int BookingId, int PetId)
        {
            return _dbSet.Where(x => x.BookingId == BookingId && x.PetId == PetId).Select(x => new ServiceOrder { 
                BookingId = x.BookingId,
                Note = x.Note,
                PetId = x.PetId,
                ServiceId = x.ServiceId,
                Service = new Service()
                {
                    Id = x.ServiceId,
                    Name = x.Service.Name,
                    Description = x.Service.Description,
                    Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(x.ServiceId, PhotoTypesConst.Service),
                },
                Quantity = x.Quantity
            });
        }
    }
}
