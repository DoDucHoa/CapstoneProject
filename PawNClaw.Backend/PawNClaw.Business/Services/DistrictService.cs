using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System.Collections.Generic;

namespace PawNClaw.Business.Services
{
    public class DistrictService
    {
        IDistrictRepository _districtRepository;

        public DistrictService(IDistrictRepository districtRepository)
        {
            _districtRepository = districtRepository;
        }

        //Get District By City Code
        public IEnumerable<District> GetDistricts(string code)
        {
            return _districtRepository.GetAll(x => x.CityCode.Trim().Equals(code));
        }
    }
}
