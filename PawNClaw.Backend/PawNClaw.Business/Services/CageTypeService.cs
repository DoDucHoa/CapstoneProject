using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class CageTypeService
    {
        ICageTypeRepository _cageTypeRepository;

        public CageTypeService(ICageTypeRepository cageTypeRepository)
        {
            _cageTypeRepository = cageTypeRepository;
        }

        public PagedList<CageType> GetCageTypes(int centerId, PagingParameter paging)
        {
            var values = _cageTypeRepository.GetAllCageWithCageType(centerId);
            return PagedList<CageType>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        public IEnumerable<CageType> GetCageTypeWithCageValidPetSizeAndBookingTime(int CenterId, List<CreatePetRequestParameter> listPets, string StartBooking, string EndBooking)
        {
            var values = _cageTypeRepository.GetCageTypeValidPetSizeAndBookingTime(CenterId, listPets, StartBooking, EndBooking);

            return values;
        }
    }
}
