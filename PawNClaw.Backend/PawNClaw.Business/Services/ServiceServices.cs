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
        IServiceOrderRepository _serviceOrderRepository;

        private readonly ApplicationDbContext _db;

        public ServiceServices(IServiceRepository serviceRepository, IServicePriceRepository servicePriceRepository,
            IServiceOrderRepository serviceOrderRepository,
            ApplicationDbContext db)
        {
            _serviceRepository = serviceRepository;
            _servicePriceRepository = servicePriceRepository;
            _serviceOrderRepository = serviceOrderRepository;
            _db = db;
        }

        public PagedList<Service> GetServices(ServiceRequestParameter serviceRequestParameter, PagingParameter paging)
        {
            var values = _serviceRepository.GetServicesOfCenter(serviceRequestParameter.CenterId);


            if (!string.IsNullOrWhiteSpace(serviceRequestParameter.Name))
            {
                values = values.Where(x => x.Name.ToLower().Equals(serviceRequestParameter.Name.ToLower().Trim()));
            }

            if (serviceRequestParameter.Id != null)
            {
                values = values.Where(x => x.Id == serviceRequestParameter.Id);
            }

            if (serviceRequestParameter.Status != null)
            {
                values = serviceRequestParameter.Status switch
                {
                    true => values.Where(x => x.Status == true),
                    false => values.Where(x => x.Status == false),
                    _ => values
                };
            }

            if (!string.IsNullOrWhiteSpace(serviceRequestParameter.sort))
            {
                switch (serviceRequestParameter.sort)
                {
                    case "name":
                        if (serviceRequestParameter.dir == "asc")
                            values = values.OrderBy(d => d.Name);
                        else if (serviceRequestParameter.dir == "desc")
                            values = values.OrderByDescending(d => d.Name);
                        break;
                }
            }
            return PagedList<Service>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        public Service GetService(int id)
        {
            return _serviceRepository.GetServiceById(id);
        }

        public async Task<int> CreateService(CreateService serviceP, List<CreateServicePrice> servicePricePs)
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
                    return service.Id;
                } 
                catch
                {
                    transaction.Rollback();
                    throw new Exception();
                }
            }
        }

        public bool UpdateService(UpdateService serviceP, List<UpdateServicePrice> updateServicePrices)
        {
            Service service = _serviceRepository.Get(serviceP.Id);
            service.Description = serviceP.Description;
            service.DiscountPrice = serviceP.DiscountPrice;
            service.ModifyDate = serviceP.ModifyDate;
            service.ModifyUser = serviceP.ModifyUser;
            service.Status = serviceP.Status;
            service.Name = serviceP.Name;

            _serviceRepository.Update(service);
            _serviceRepository.SaveDbChange();

            foreach (var item in updateServicePrices)
            {
                ServicePrice servicePrice = _servicePriceRepository.Get(item.Id);

                servicePrice.Price = item.Price;
                servicePrice.MinWeight = item.MinWeight;
                servicePrice.MaxWeight = item.MaxWeight;
                servicePrice.ModifyUser = item.ModifyUser;
                servicePrice.Status = item.Status;
                servicePrice.ServiceId = item.ServiceId;

                _servicePriceRepository.Update(servicePrice);
                _servicePriceRepository.SaveDbChange();
            }
            return true;
        }

        public bool DeleteService(int id)
        {
            Service service = _serviceRepository.Get(id);
            service.Status = false;

            var serviceOerder = _serviceOrderRepository.GetAll(x => x.ServiceId == id && (x.Booking.StatusId == 1 || x.Booking.StatusId == 2));
            if (serviceOerder.Count() > 0)
            {
                throw new Exception("Cant delete");
            }

            _serviceRepository.Update(service);
            _serviceRepository.SaveDbChange();

            List<ServicePrice> servicePrices = (List<ServicePrice>)_servicePriceRepository.GetAll(x => x.ServiceId == id);

            foreach (var item in servicePrices)
            {
                item.Status = false;
                _servicePriceRepository.Update(item);
                _servicePriceRepository.SaveDbChange();
            }

            return true;
        }
    }
}
