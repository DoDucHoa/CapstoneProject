using PawNClaw.Data.Database;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Interface
{
    public interface ICageTypeRepository : IRepository<CageType>
    {
        public IEnumerable<CageType> GetAllCageWithCageType(int centerId);

        public IEnumerable<CageType> GetCageTypeValidPetSizeAndBookingTime(int CenterId, List<List<CreatePetRequestParameter>> listPets, string StartBooking, string EndBooking);
    }
}
