using Microsoft.EntityFrameworkCore.Storage;
using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class ServiceServices
    {
        IServiceRepository _serviceRepository;
        IServicePriceRepository _servicePriceRepository;

        private readonly ApplicationDbContext _db;

        public ServiceServices(IServiceRepository serviceRepository, IServicePriceRepository servicePriceRepository,
            ApplicationDbContext db)
        {
            _serviceRepository = serviceRepository;
            _servicePriceRepository = servicePriceRepository;
            _db = db;
        }

        public PagedList<Service> GetServices(int centerId, PagingParameter paging)
        {
            var values = _serviceRepository.GetServicesOfCenter(centerId);

            return PagedList<Service>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        public Service GetService(int id)
        {
            return _serviceRepository.Get(id);
        }

        public async Task<bool> CreateService(CreateService serviceP, List<CreateServicePrice> servicePricePs)
        {
            using (IDbContextTransaction transaction = _db.Database.BeginTransaction())
            {
                try
                {
                    Service service = new Service()
                    {
                        Description = serviceP.Description,
                        DiscountPrice = serviceP.DiscountPrice,
                        CreateDate = serviceP.CreateDate,
                        ModifyDate = serviceP.ModifyDate,
                        CreateUser = serviceP.CreateUser,
                        ModifyUser = serviceP.ModifyUser,
                        Status = true,
                        CenterId = serviceP.CenterId,
                        Name = serviceP.Name
                    };

                    _serviceRepository.Add(service);
                    await _serviceRepository.SaveDbChangeAsync();

                    if (servicePricePs.Count < 1)
                    {
                        throw new Exception("Must have price");
                    }

                    foreach (var servicePriceP in servicePricePs)
                    {
                        ServicePrice servicePrice = new ServicePrice()
                        {
                            Price = servicePriceP.Price,
                            MinWeight = servicePriceP.MinWeight,
                            MaxWeight = servicePriceP.MaxWeight,
                            CreateUser = servicePriceP.CreateUser,
                            ModifyUser = servicePriceP.ModifyUser,
                            Status = true,
                            ServiceId = service.Id
                        };

                        _servicePriceRepository.Add(servicePrice);
                        await _servicePriceRepository.SaveDbChangeAsync();
                    }

                    transaction.Commit();
                    return true;
                } 
                catch
                {
                    transaction.Rollback();
                    throw new Exception();
                }
            }
        }

        public bool UpdateService(Service service)
        {
            _serviceRepository.Update(service);
            _serviceRepository.SaveDbChange();
            return true;
        }
    }
}
