using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System.Collections.Generic;

namespace PawNClaw.Business.Services
{
    public class CityService
    {
        ICityRepository _cityRepository;

        public CityService(ICityRepository cityRepository)
        {
            _cityRepository = cityRepository;
        }

        //Get All
        public IEnumerable<City> GetCities()
        {
            return _cityRepository.GetAll();
        }
    }
}
