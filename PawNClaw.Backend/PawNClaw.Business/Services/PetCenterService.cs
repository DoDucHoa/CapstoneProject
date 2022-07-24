using PawNClaw.Data.Const;
using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using static PawNClaw.Data.Repository.PetCenterRepository;

namespace PawNClaw.Business.Services
{
    public class PetCenterService
    {
        IPetCenterRepository _petCenterRepository;
        IStaffRepository _staffRepository;

        public PetCenterService(IPetCenterRepository petCenterRepository, IStaffRepository staffRepository)
        {
            _petCenterRepository = petCenterRepository;
            _staffRepository = staffRepository;
        }

        //Get All
        public PagedList<PetCenter> GetAll(string includeProperties, PagingParameter paging)
        {
            var values = _petCenterRepository.GetAll(includeProperties: "Brand");

            return PagedList<PetCenter>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        //Get Id
        public PetCenter GetById(int id)
        {
            var value = _petCenterRepository.GetFirstOrDefault(x => x.Id == id);
            return value;
        }

        //Get By Id With Cage Service and Supply
        public PetCenter GetDetailById(int id, List<List<PetRequestParameter>> _petRequests, string StartBooking, string EndBooking)
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

            var value = _petCenterRepository.GetPetCenterById(id, petSizeCages, StartBooking, EndBooking);
            return value;
        }

        //Get By Brand Id
        public IEnumerable<PetCenter> GetByBrand(int id)
        {
            var values = _petCenterRepository.GetAll(x => x.BrandId == id);

            return values;
        }

        //Get By Staff Id
        public PetCenter GetByStaffId(int id)
        {
            var staff = _staffRepository.GetFirstOrDefault(x => x.Id == id);
            var value = _petCenterRepository.GetFirstOrDefault(x => x.Id == staff.CenterId);
            return value;
        }

        //Get By Name
        public PagedList<PetCenter> GetByName(string name, PagingParameter paging)
        {
            var values = _petCenterRepository.GetAll(x => x.Name.Contains(name));

            return PagedList<PetCenter>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        //Add
        public int Add(PetCenter petCenter)
        {
            try
            {
                if (_petCenterRepository.GetFirstOrDefault(x => x.Name.Trim().Equals(petCenter.Name)) != null)
                    return -1;
                if (_petCenterRepository.GetFirstOrDefault(x => x.Address.Trim().Equals(petCenter.Address)) != null)
                    return -1;
                _petCenterRepository.Add(petCenter);
                _petCenterRepository.SaveDbChange();
                return 1;
            }
            catch
            {
                return -1;
            }
        }

        //Update
        public bool Update(PetCenter petCenter)
        {
            try
            {
                _petCenterRepository.Update(petCenter);
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
