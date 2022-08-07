using Microsoft.EntityFrameworkCore;
using PawNClaw.Data.Const;
using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class StaffRepository : Repository<Staff>, IStaffRepository
    {
        private readonly ApplicationDbContext _db;
        IAccountRepository _accountRepository;
        IPhotoRepository _photoRepository;

        public StaffRepository(ApplicationDbContext db, IAccountRepository accountRepository, IPhotoRepository photoRepository) : base(db)
        {
            _db = db;
            _accountRepository = accountRepository;
            _photoRepository = photoRepository;
        }

        public Staff GetStaffWithAccount(int staffId)
        {
            try
            {
                var staff = _dbSet.Include(x => x.IdNavigation).Select(x => new Staff() {
                    CenterId = x.CenterId,
                    CreateDate = x.CreateDate,
                    Id = x.Id,
                    IdNavigation = x.IdNavigation,
                    ModifyDate = x.ModifyDate,
                    ModifyUser = x.ModifyUser,
                    CreateUser = x.CreateUser,
                    Name = x.Name,
                    Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(x.Id, PhotoTypesConst.Account),
                }).First(x => x.Id == staffId);
                return staff;
            }
            catch
            {
                throw new Exception();
            }
        } 

        public bool UpdateStaffById(UpdateStaffParameter updateStaffParameter)
        {
            try
            {
                var staff = _dbSet.FirstOrDefault(x => x.Id == updateStaffParameter.Id);
                var account = _accountRepository.GetFirstOrDefault(x => x.Id == updateStaffParameter.Id);

                staff.ModifyDate = DateTime.Now;
                staff.ModifyUser = updateStaffParameter.ModifyUser;
                staff.Name = updateStaffParameter.Name;
                
                account.Phone = updateStaffParameter.Phone;
                if(updateStaffParameter.Status != null)
                {
                    account.Status = updateStaffParameter.Status;
                }
                _dbSet.Update(staff);
                _db.SaveChanges();

                _accountRepository.Update(account);
                _accountRepository.SaveDbChange();

                return true;
            }
            catch
            {
                throw new Exception();
            }
        }
    }
}
