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
    public class CageTypeService
    {
        ICageTypeRepository _cageTypeRepository;
        IPriceRepository _priceRepository;
        IFoodScheduleRepository _foodScheduleRepository;

        private readonly ApplicationDbContext _db;

        public CageTypeService(ICageTypeRepository cageTypeRepository, IPriceRepository priceRepository,
            IFoodScheduleRepository foodScheduleRepository,
            ApplicationDbContext db)
        {
            _cageTypeRepository = cageTypeRepository;
            _priceRepository = priceRepository;
            _foodScheduleRepository = foodScheduleRepository;
            _db = db;
        }

        public PagedList<CageType> GetCageTypes(CageTypeRequestParameter cageTypeRequestParameter, PagingParameter paging)
        {
            var values = _cageTypeRepository.GetAllCageWithCageType(cageTypeRequestParameter.CenterId);

            if (!string.IsNullOrWhiteSpace(cageTypeRequestParameter.TypeName))
            {
                values = values.Where(x => x.TypeName.ToLower().Contains(cageTypeRequestParameter.TypeName.ToLower()));
            }

            if (cageTypeRequestParameter.id != null)
            {
                values = values.Where(x => x.Id == cageTypeRequestParameter.id);
            }

            if (cageTypeRequestParameter.IsSingle != null)
            {
                values = cageTypeRequestParameter.IsSingle switch
                {
                    true => values.Where(x => x.IsSingle == true),
                    false => values.Where(x => x.IsSingle == false),
                    _ => values
                };
            }

            if (cageTypeRequestParameter.Status != null)
            {
                values = cageTypeRequestParameter.Status switch
                {
                    true => values.Where(x => x.Status == true),
                    false => values.Where(x => x.Status == false),
                    _ => values
                };
            }

            if (!string.IsNullOrWhiteSpace(cageTypeRequestParameter.sort))
            {
                switch (cageTypeRequestParameter.sort)
                {
                    case "typename":
                        if (cageTypeRequestParameter.dir == "asc")
                            values = values.OrderBy(d => d.TypeName);
                        else if (cageTypeRequestParameter.dir == "desc")
                            values = values.OrderByDescending(d => d.TypeName);
                        break;
                }
            }

            return PagedList<CageType>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        public IEnumerable<CageType> GetCageTypeWithCageValidPetSizeAndBookingTime(int CenterId, List<PetRequestForSearchCenter> listPets, string StartBooking, string EndBooking)
        {
            var values = _cageTypeRepository.GetCageTypeValidPetSizeAndBookingTime(CenterId, listPets, StartBooking, EndBooking);

            return values;
        }

        public async Task<int> CreateCageType(CreateCageTypeParameter createCageTypeParameter, List<CreatePriceParameter> createPriceParameters, List<CreateFoodSchedule> foodSchedules)
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
            cageType.ModifyUser = createCageTypeParameter.ModifyUser;
            cageType.ModifyDate = createCageTypeParameter.ModifyDate;
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
                        price.ModifyDate = createPriceParameter.ModifyDate;
                        price.ModifyUser = createPriceParameter.ModifyUser;
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

                    if (foodSchedules.Count < 1)
                    {
                        throw new Exception("Need Food Schedule");
                    }

                    foreach (var foodSchedule in foodSchedules)
                    {
                        FoodSchedule food = new FoodSchedule()
                        {
                            FromTime = foodSchedule.FromTime.TimeOfDay,
                            ToTime = foodSchedule.ToTime.TimeOfDay,
                            Name = foodSchedule.Name,
                        };

                        food.CageTypeId = cageType.Id;
                        _foodScheduleRepository.Add(food);
                        await _foodScheduleRepository.SaveDbChangeAsync();
                    }

                    transaction.Commit();
                }
                catch
                {
                    transaction.Rollback();
                    throw new Exception();
                }
            }

            return cageType.Id;
        }

        public bool Update(UpdateCageTypeParameter cageTypeP, List<UpdatePriceParameter> updatePriceParameters, List<UpdateFoodSchedule> updateFoodSchedules)
        {
            CageType cageType = _cageTypeRepository.Get(cageTypeP.Id);
            cageType.TypeName = cageTypeP.TypeName;
            cageType.Description = cageTypeP.Description;
            cageType.IsSingle = cageTypeP.IsSingle;
            cageType.ModifyDate = cageTypeP.ModifyDate;
            cageType.Status = cageTypeP.Status;

            _cageTypeRepository.Update(cageType);
            _cageTypeRepository.SaveDbChange();

            foreach (var item in updatePriceParameters)
            {
                Price price = _priceRepository.Get(item.Id);
                price.UnitPrice = item.UnitPrice;
                price.CreateDate = item.CreateDate;
                price.CreateUser = item.CreateUser;
                price.PriceTypeCode = item.PriceTypeCode;
                price.ModifyDate = item.ModifyDate;
                price.ModifyUser = item.ModifyUser;
                price.Status = true;
                price.CageTypeId = cageType.Id;
                _priceRepository.Update(price);
                _priceRepository.SaveDbChange();
            }

            foreach (var item in updateFoodSchedules)
            {
                FoodSchedule food = _foodScheduleRepository.Get(item.Id);
                food.FromTime = item.FromTime.TimeOfDay;
                food.ToTime = item.ToTime.TimeOfDay;
                food.Name = item.Name;
                food.CageTypeId = item.Id;
                _foodScheduleRepository.Update(food);
                _foodScheduleRepository.SaveDbChange();
            }
            return true;
        }

        public bool Delete(int id)
        {
            var cagetype = _cageTypeRepository.GetCageTypeWithCageAndPrice(id);
            if (cagetype.Cages.Any(x => x.BookingDetails.Any(bookingdetail => bookingdetail.Booking.StatusId == 1 || bookingdetail.Booking.StatusId == 2)))
            {
                throw new Exception("Cant delete this cage type");
            }
            else
            {
                cagetype = _cageTypeRepository.Get(id);
                cagetype.Status = false;
                _cageTypeRepository.Update(cagetype);
                _cageTypeRepository.SaveDbChange();
                return true;
            }
        }

        public CageType GetCageTypeWithCageAndPrice(int id)
        {
            var value = _cageTypeRepository.GetCageTypeWithCageAndPrice(id);

            DateTime dateTime = DateTime.Today;

            foreach (var item in value.FoodSchedules)
            {
                item.FromTimeDate = dateTime.SetTime(item.FromTime.Hours, item.FromTime.Minutes, item.FromTime.Seconds);
                item.ToTimeDate = dateTime.SetTime(item.ToTime.Hours, item.ToTime.Minutes, item.ToTime.Seconds);
            }

            return value;
        }
    }
}
