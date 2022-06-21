using Microsoft.EntityFrameworkCore.Storage;
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
        IPriceRepository _priceRepository;

        private readonly ApplicationDbContext _db;

        public CageTypeService(ICageTypeRepository cageTypeRepository, IPriceRepository priceRepository, 
            ApplicationDbContext db)
        {
            _cageTypeRepository = cageTypeRepository;
            _priceRepository = priceRepository;
            _db = db;
        }

        public PagedList<CageType> GetCageTypes(int centerId, PagingParameter paging)
        {
            var values = _cageTypeRepository.GetAllCageWithCageType(centerId);
            return PagedList<CageType>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        public IEnumerable<CageType> GetCageTypeWithCageValidPetSizeAndBookingTime(int CenterId, List<PetRequestForSearchCenter> listPets, string StartBooking, string EndBooking)
        {
            var values = _cageTypeRepository.GetCageTypeValidPetSizeAndBookingTime(CenterId, listPets, StartBooking, EndBooking);

            return values;
        }

        public async Task<bool> CreateCageType(CreateCageTypeParameter createCageTypeParameter, List<CreatePriceParameter> createPriceParameters)
        {
            CageType cageType = new CageType();

            cageType.TypeName = createCageTypeParameter.TypeName;
            cageType.Description = createCageTypeParameter.Description;
            cageType.Height = createCageTypeParameter.Height;
            cageType.Width = createCageTypeParameter.Width;
            cageType.Length = createCageTypeParameter.Length;
            cageType.IsSingle = createCageTypeParameter.IsSingle;
            cageType.CreateDate = createCageTypeParameter.CreateDate;
            cageType.CreateUser = createCageTypeParameter.CreateUser;
            cageType.CenterId = createCageTypeParameter.CenterId;
            cageType.Status = true;


            using (IDbContextTransaction transaction = _db.Database.BeginTransaction())
            {
                try
                {
                    _cageTypeRepository.Add(cageType);
                    await _cageTypeRepository.SaveDbChangeAsync();

                    bool CheckPrice = false;
                    foreach (var createPriceParameter in createPriceParameters)
                    {
                        if (_priceRepository.GetAll(x => x.CageTypeId == cageType.Id && x.PriceTypeCode == createPriceParameter.PriceTypeCode && x.Status == true).Count() > 0)
                        {
                            if (!createPriceParameter.PriceTypeCode.Equals("PRICE-004"))
                            {
                                transaction.Rollback();
                                throw new Exception("Duplicate Price");
                            }
                        }
                        if (createPriceParameter.PriceTypeCode.Equals("PRICE-001"))
                        {
                            CheckPrice = true;
                        }

                        Price price = new Price();
                        price.UnitPrice = createPriceParameter.UnitPrice;
                        price.CreateDate = createPriceParameter.CreateDate;
                        price.CreateUser = createPriceParameter.CreateUser;
                        price.PriceTypeCode = createPriceParameter.PriceTypeCode;
                        price.Status = true;
                        price.CageTypeId = cageType.Id;

                        _priceRepository.Add(price);
                        await _priceRepository.SaveDbChangeAsync();
                    }

                    if (!CheckPrice)
                    {
                        transaction.Rollback();
                        throw new Exception("Need Price Is - 'Giá Mặc Định' ");
                    }

                    transaction.Commit();
                }
                catch
                {
                    transaction.Rollback();
                    throw new Exception();
                }
            }

            return true;
        }
    }
}
