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
    public class SupplyOrderRepository : Repository<SupplyOrder>, ISupplyOrderRepository
    {
        IPhotoRepository _photoRepository;
        public SupplyOrderRepository(ApplicationDbContext db, IPhotoRepository photoRepository) : base(db)
        {
            _photoRepository = photoRepository;
        }

        public void RemoveSupplyOrder(int BookingId, int SupplyId)
        {
            _dbSet.Remove(_dbSet.Find(SupplyId,BookingId));
        }

        public IEnumerable<SupplyOrder> GetSupplyOrdersByPetIdAndBookingId(int BookingId, int PetId)
        {
            return _dbSet.Where(x => x.BookingId == BookingId && x.PetId == PetId).Select(x => new SupplyOrder { 
                BookingId = x.BookingId,
                Note = x.Note,
                Supply = new Supply() {
                    Id = x.SupplyId,
                    Name = x.Supply.Name,
                    Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(x.SupplyId, PhotoTypesConst.Supply),
                },
                PetId = x.PetId,
                SupplyId = x.SupplyId,
                Quantity = x.Quantity
            });
        }
    }
}
