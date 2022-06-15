using PawNClaw.Data.Database;
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
    }
}
