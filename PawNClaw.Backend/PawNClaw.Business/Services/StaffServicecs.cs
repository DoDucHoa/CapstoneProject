using PawNClaw.Data.Const;
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
    public class StaffServicecs
    {
        IStaffRepository _staffRepository;
        IAccountRepository _accountRepository;
        IPhotoRepository _photoRepository;

        public StaffServicecs(IStaffRepository staffRepository, IAccountRepository accountRepository, IPhotoRepository photoRepository)
        {
            _staffRepository = staffRepository;
            _accountRepository = accountRepository;
            _photoRepository = photoRepository;
        }

        //Get All
        public PagedList<Staff> GetAll(int id, string includeProperties, PagingParameter paging)
        {
            var values = _staffRepository.GetAll(includeProperties: "IdIdNavigation");

            if (id > 0)
            {
                values = values.Where(x => x.Id == id);
            }

            return PagedList<Staff>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        //Get Id
        public Staff GetById(int id)
        {
            try
            {
                var value = _staffRepository.GetStaffWithAccount(id);

                return value;
            }
            catch
            {
                throw new Exception();
            }
        }

        //Get all staff by center
        public IEnumerable<Staff> GetAllByCenterId(int id)
        {
            var values = _staffRepository.GetAll(x => x.CenterId == id, includeProperties: "IdNavigation");
            return values;
        }

        //Get Staff By Center Id
        public PagedList<Staff> GetByCenterId(int id, string name, bool? status, PagingParameter paging)
        {
            var values = _staffRepository.GetAll(x => x.CenterId == id, includeProperties: "IdNavigation").Select(x => new Staff()
            {
                CenterId = x.CenterId,
                CreateDate = x.CreateDate,
                Id = x.Id,
                IdNavigation = x.IdNavigation,
                ModifyDate = x.ModifyDate,
                ModifyUser = x.ModifyUser,
                CreateUser = x.CreateUser,
                Name = x.Name,
                Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(x.Id, PhotoTypesConst.Account)
            }).AsQueryable();

            if (!string.IsNullOrWhiteSpace(name))
            {
                values = values.Where(x => name.Contains(x.Name.Trim()));
            }
            values = status switch
            {
                true => values.Where(x => x.IdNavigation.Status == true),
                false => values.Where(x => x.IdNavigation.Status == false),
                _ => values
            };

            return PagedList<Staff>.ToPagedList(values.AsQueryable(),
            paging.PageNumber,
            paging.PageSize);
        }

        //Add
        public async Task<int> AddAsync(CreateStaffParameter staff)
        {
            try
            {
                var account = new Account
                {
                    UserName = staff.UserName,
                    CreatedUser = staff.CreateUser,
                    Phone = staff.Phone,
                    RoleCode = staff.RoleCode
                };

                _accountRepository.Add(account);
                await _accountRepository.SaveDbChangeAsync();
                account = _accountRepository.GetFirstOrDefault(x => x.UserName == staff.UserName);

                var staffToDb = new Staff
                {
                    Id = account.Id,
                    CenterId = staff.CenterId,
                    CreateUser = staff.CreateUser,
                    ModifyUser = staff.CreateUser,
                    Name = staff.Name
                };

                _staffRepository.Add(staffToDb);
                await _staffRepository.SaveDbChangeAsync();
                return staffToDb.Id;
            }
            catch
            {
                throw new Exception();
            }
        }

        //Update
        public bool Update(Staff staff)
        {
            try
            {
                _staffRepository.Update(staff);
                _staffRepository.SaveDbChange();
                return true;
            }
            catch
            {
                return false;
            }
        }

        //Update Staff by Id
        public bool UpdateById(UpdateStaffParameter staff)
        {
            try
            {
                _staffRepository.UpdateStaffById(staff);
                _staffRepository.SaveDbChange();
                return true;
            }
            catch
            {
                return false;
            }
        }

        //Ban staff
        public bool banStaff(int id)
        {
            try
            {
                var staff = _accountRepository.GetFirstOrDefault(x => x.Id == id);
                if(staff.Status == true)
                {
                    staff.Status = false;
                }
                else
                {
                    staff.Status = true;
                }

                _accountRepository.Update(staff);
                _accountRepository.SaveDbChange();
                return true;
            }
            catch
            {
                throw new Exception();
            }
        }

        //Delete
        public bool Delete(int id)
        {
            try
            {
                var objFromDb = _staffRepository.Get(id);
                if (objFromDb != null)
                {
                    _staffRepository.Update(objFromDb);
                    _staffRepository.SaveDbChange();
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
                var objFromDb = _staffRepository.Get(id);
                if (objFromDb != null)
                {
                    _staffRepository.Update(objFromDb);
                    _staffRepository.SaveDbChange();
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
