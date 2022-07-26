﻿using Microsoft.EntityFrameworkCore.Storage;
using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using System;
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

        public async Task<bool> CreateService(Service service, ServicePrice servicePrice)
        {
            using (IDbContextTransaction transaction = _db.Database.BeginTransaction())
            {
                try
                {
                    _serviceRepository.Add(service);
                    await _serviceRepository.SaveDbChangeAsync();

                    servicePrice.ServiceId = service.Id;

                    _servicePriceRepository.Add(servicePrice);
                    await _servicePriceRepository.SaveDbChangeAsync();

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
