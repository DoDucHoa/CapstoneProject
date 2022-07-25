using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Interface
{
    public interface ICageRepository : IRepository<Cage>
    {
        public int CountCageByCageTypeIDExceptBusyCage(int Id, bool IsSingle, List<string> cageCodesInvalid);

        public Cage GetCageWithCageType(string CageCode, int CenterId);

        public Cage GetCage(string Code, int CenterId);

        public bool UpdateCageStatus(List<String> CageCodes, int centerId);

        public IEnumerable<Cage> GetCages(int CenterId);
    }
}
