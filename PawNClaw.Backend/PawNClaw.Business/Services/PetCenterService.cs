using Microsoft.EntityFrameworkCore.Storage;
using Newtonsoft.Json.Linq;
using PawNClaw.Data.Const;
using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using static PawNClaw.Data.Repository.PetCenterRepository;

namespace PawNClaw.Business.Services
{
    public class PetCenterService
    {
        IPetCenterRepository _petCenterRepository;
        IStaffRepository _staffRepository;
        ILocationRepository _locationRepository;

        private readonly ApplicationDbContext _db;

        public PetCenterService(IPetCenterRepository petCenterRepository, IStaffRepository staffRepository,
            ILocationRepository locationRepository, ApplicationDbContext db)
        {
            _petCenterRepository = petCenterRepository;
            _staffRepository = staffRepository;
            _locationRepository = locationRepository;
            _db = db;
        }

        //Get All
        public PagedList<PetCenter> GetAll(string includeProperties, PagingParameter paging)
        {
            var values = _petCenterRepository.GetAll(includeProperties: "Brand,Bookings");

            return PagedList<PetCenter>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        public PagedList<PetCenter> GetAllForAdmin(string name, bool? status, PagingParameter paging)
        {
            var values = _petCenterRepository.GetPetCentersForAdmin();

            if (!String.IsNullOrEmpty(name))
            {
                values = values.Where(x => x.Name.Contains(name));
            }

            if (status != null)
            {
                values = values.Where(x => x.Status == status);
            }

            return PagedList<PetCenter>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        //Get Id
        public PetCenter GetById(int id)
        {
            var value = _petCenterRepository.GetFirstOrDefault(x => x.Id == id,includeProperties:"Bookings");
            return value;
        }

        public PetCenter GetByIdForAdmin(int id)
        {
            var value = _petCenterRepository.GetPetCenterById(id);

            DateTime dateTime = DateTime.Today;

            var checkin = value.Checkin.Split(":");
            var checkout = value.Checkout.Split(":");

            var open = value.OpenTime.Split(":");
            var close = value.CloseTime.Split(":");



            value.OpenTimeDate = dateTime.SetTime(Int32.Parse(open[0]), Int32.Parse(open[1]), Int32.Parse("00"));
            value.CloseTimeDate = dateTime.SetTime(Int32.Parse(close[0]), Int32.Parse(close[1]), Int32.Parse("00"));
            value.CheckinDate = dateTime.SetTime(Int32.Parse(checkin[0]), Int32.Parse(checkin[1]), Int32.Parse("00"));
            value.CheckoutDate = dateTime.SetTime(Int32.Parse(checkout[0]), Int32.Parse(checkout[1]), Int32.Parse("00"));

            return value;
        }

        //Get Detail By Id after searching
        public PetCenter GetDetailByCenterId(int id)
        {
            var value = _petCenterRepository.GetPetCenterByIdAfterSearchName(id);
            return value;
        }

        //Get By Id With Cage Service and Supply
        public PetCenter GetDetailById(int id, int customerId, List<List<PetRequestParameter>> _petRequests, string StartBooking, string EndBooking)
        {
            List<PetSizeCage> PetSizes = new List<PetSizeCage>();

            foreach (var _petRequest in _petRequests)
            {
                int Count = 0;
                decimal Height = 0;
                decimal Width = 0;
                foreach (var _pet in _petRequest)
                {
                    if (_pet.Height == null || _pet.Length == null || _pet.Weight == null)
                    {
                        throw new Exception("Pet Size NULL");
                    }
                    if (Height < (decimal)(_pet.Height + SearchConst.HeightAdd))
                    {
                        Height = (decimal)(_pet.Height + SearchConst.HeightAdd);
                    }

                    Width += (decimal)Math.Round((((double)_pet.Length) + ((double)_pet.Height)) / SearchConst.WidthRatio, 0);
                    Count += 1;
                }

                PetSizeCage petSize = new PetSizeCage();
                petSize.Height = Height;
                petSize.Width = Width;
                if (Count > 1) petSize.IsSingle = false;
                PetSizes.Add(petSize);
            }

            PetSizeCage petSizeCages = new PetSizeCage
            {
                Height = PetSizes.Min(x => x.Height),
                Width = PetSizes.Min(x => x.Width),
                IsSingle = true
            };

            var value = _petCenterRepository.GetPetCenterById(id, customerId, petSizeCages, StartBooking, EndBooking);
            return value;
        }

        //Get By Brand Id
        public IEnumerable<PetCenter> GetByBrand(int id)
        {
            var values = _petCenterRepository.GetAll(x => x.BrandId == id,includeProperties:"Bookings");

            return values;
        }

        //Get By Staff Id
        public PetCenter GetByStaffId(int id)
        {
            var staff = _staffRepository.GetFirstOrDefault(x => x.Id == id);
            var value = _petCenterRepository.GetFirstOrDefault(x => x.Id == staff.CenterId, includeProperties: "Bookings");
            return value;
        }

        //Get By Name
        public PagedList<PetCenter> GetByName(string name, PagingParameter paging)
        {
            var values = _petCenterRepository.GetAll(x => x.Name.Contains(name),includeProperties: "Bookings");

            return PagedList<PetCenter>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        //Add
        public async Task<int> Add(PetCenter petCenter, Location location, string fullAddress)
        {

            using (IDbContextTransaction transaction = _db.Database.BeginTransaction())
            {
                try
                {
                    if (_petCenterRepository.GetFirstOrDefault(x => x.Name.Trim().Equals(petCenter.Name)) != null)
                        throw new Exception("This Name Already Existed");
                    if (_petCenterRepository.GetFirstOrDefault(x => x.Address.Trim().Equals(petCenter.Address)) != null)
                        throw new Exception("This Address Already Existed");
                    _petCenterRepository.Add(petCenter);
                    await _petCenterRepository.SaveDbChangeAsync();

                    location.Id = petCenter.Id;
                    var client = new HttpClient();
                    string url = "https://rsapi.goong.io/geocode?address=" + HttpUtility.UrlEncode(fullAddress) + SearchConst.GoongAPIKey;
                    Console.WriteLine(url);
                    HttpResponseMessage response = await client.GetAsync(url);
                    response.EnsureSuccessStatusCode();

                    var result = await response.Content.ReadAsStringAsync();

                    var cust = JObject.Parse(result);

                    location.Latitude = cust["results"][0]["geometry"]["location"]["lat"].ToString();
                    location.Longtitude = cust["results"][0]["geometry"]["location"]["lng"].ToString();

                    _locationRepository.Add(location);
                    await _locationRepository.SaveDbChangeAsync();

                    transaction.Commit();

                    return petCenter.Id;
                }
                catch
                {
                    transaction.Rollback();
                    throw new Exception();
                }
            }
        }

        //Update full for admin
        public async Task<bool> UpdateForAdminAsync(UpdatePetCenterForAdminParam petCenterRequestParameter)
        {
            try
            {
                PetCenter petCenter = _petCenterRepository.GetPetCenterWithLocation(petCenterRequestParameter.Id);
                petCenter.Address = petCenterRequestParameter.Address;
                petCenter.Phone = petCenterRequestParameter.Phone;
                petCenter.ModifyDate = DateTime.Now;
                petCenter.ModifyUser = petCenterRequestParameter.ModifyUser;
                petCenter.OpenTime = petCenterRequestParameter.OpenTime;
                petCenter.CloseTime = petCenterRequestParameter.CloseTime;
                petCenter.Checkin = petCenterRequestParameter.CheckIn;
                petCenter.Checkout = petCenterRequestParameter.CheckOut;

                var client = new HttpClient();
                string url = "https://rsapi.goong.io/geocode?address=" + HttpUtility.UrlEncode(petCenter.Address) +SearchConst.GoongAPIKey;
                Console.WriteLine(url);
                HttpResponseMessage response = await client.GetAsync(url);
                response.EnsureSuccessStatusCode();

                var result = await response.Content.ReadAsStringAsync();
                var cust = JObject.Parse(result);

                petCenter.Location.Latitude = cust["results"][0]["geometry"]["location"]["lat"].ToString();
                petCenter.Location.Longtitude = cust["results"][0]["geometry"]["location"]["lng"].ToString();
                petCenter.Location.CityCode = petCenterRequestParameter.CityCode;
                petCenter.Location.DistrictCode = petCenterRequestParameter.DistrictCode;
                petCenter.Location.WardCode = petCenterRequestParameter.WardCode;

                _petCenterRepository.Update(petCenter);
                _petCenterRepository.SaveDbChange();

                return true;
            }
            catch
            {
                throw new Exception();
            }
        }

        //Update for center owner
        public bool UpdateForOwner(UpdatePetCenterForOwnerParam petCenter)
        {
            try
            {
                PetCenter center = _petCenterRepository.GetFirstOrDefault(x => x.Id == petCenter.Id);
                center.OpenTime = petCenter.OpenTime;
                center.CloseTime = petCenter.CloseTime;
                center.Checkin = petCenter.CheckIn;
                center.Checkout = petCenter.CheckOut;
                center.Description = petCenter.Description;
                center.Phone = petCenter.Phone;
                center.ModifyDate = DateTime.Now;
                center.ModifyUser = petCenter.ModifyUser;


                _petCenterRepository.Update(center);
                _petCenterRepository.SaveDbChange();
                return true;
            }
            catch
            {
                return false;
            }
        }


        //Delete
        public bool Delete(int id)
        {
            try
            {
                var objFromDb = _petCenterRepository.Get(id);
                objFromDb.Status = false;
                if (objFromDb != null)
                {
                    _petCenterRepository.Update(objFromDb);
                    _petCenterRepository.SaveDbChange();
                    return true;
                }
            }
            catch
            {
                return false;
            }
            return false;
        }

        //Restore
        public bool Restore(int id)
        {
            try
            {
                var objFromDb = _petCenterRepository.Get(id);
                objFromDb.Status = true;
                if (objFromDb != null)
                {
                    _petCenterRepository.Update(objFromDb);
                    _petCenterRepository.SaveDbChange();
                    return true;
                }
            }
            catch
            {
                return false;
            }
            return false;
        }
    }
}
