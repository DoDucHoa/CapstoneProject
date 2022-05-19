using PawNClaw.Data.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static PawNClaw.Data.Repository.PetCenterRepository;

namespace PawNClaw.Data.Interface
{
    public interface IPetCenterRepository : IRepository<PetCenter>
    {
        public IEnumerable<PetCenter> SearchPetCenter(string City, string District);

        public IEnumerable<PetCenter> SearchPetCenterQuery(string City, string District,
            string StartBooking, string EndBooking, List<PetSizeCage> PetSizes);

        public IEnumerable<PetCenter> SearchPetCenterQueryNonBooking(string City, string District,
            string StartBooking, string EndBooking, List<PetSizeCage> PetSizes);

        public PetCenter GetPetCenterById(int id, PetSizeCage PetSizes);
    }
}
