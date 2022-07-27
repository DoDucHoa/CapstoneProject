using Microsoft.EntityFrameworkCore;
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

        public StaffRepository(ApplicationDbContext db, IAccountRepository accountRepository) : base(db)
        {
            _db = db;
            _accountRepository = accountRepository;
        }

        public Staff GetStaffWithAccount(int staffId)
        {
            try
            {
                var staff = _dbSet.Include(x => x.IdNavigation).First(x => x.Id == staffId);
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
