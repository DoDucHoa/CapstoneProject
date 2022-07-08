using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using System.Linq;

namespace PawNClaw.Business.Services
{
    public class ServiceServices
    {
        IServiceRepository _serviceRepository;

        public ServiceServices(IServiceRepository serviceRepository)
        {
            _serviceRepository = serviceRepository;
        }

        public PagedList<Service> GetServices(int centerId, PagingParameter paging)
        {
            var values = _serviceRepository.GetServicesOfCenter(centerId);

            return PagedList<Service>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }
    }
}
