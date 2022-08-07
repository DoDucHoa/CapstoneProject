using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class WardService
    {
        IWardRepository _wardRepository;

        public WardService(IWardRepository wardRepository)
        {
            _wardRepository = wardRepository;
        }

        public IEnumerable<Ward> GetWardsByDistrictCode(string DistrictCode)
        {
            return _wardRepository.GetAll(x => x.DistrictCode.Trim().Equals(DistrictCode));
        }
    }
}
