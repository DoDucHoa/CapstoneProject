using Microsoft.EntityFrameworkCore;
using PawNClaw.Data.Const;
using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class AccountRepository : Repository<Account>, IAccountRepository
    {
        private readonly ApplicationDbContext _db;

        private readonly IPhotoRepository _photoRepository;

        public AccountRepository(ApplicationDbContext db, IPhotoRepository photoRepository) : base(db)
        {
            _db = db;
            _photoRepository = photoRepository;
        }

        public Account GetAccountWithInFor(int id)
        {
            Account query = _dbSet
                .Include(x => x.Admin)
                .Include(x => x.Owner)
                .Include(x => x.Customer)
                .Include(x => x.StaffIdNavigation)
                .Select(x => new Account { 
                    Id = x.Id,
                    UserName = x.UserName,
                    CreatedUser = x.CreatedUser,
                    DeviceId = x.DeviceId,
                    Phone = x.Phone,
                    Status = x.Status,
                    RoleCode = x.RoleCode,
                    Admin = x.Admin,
                    Owner = x.Owner,
                    Customer = x.Customer,
                    StaffIdNavigation = x.StaffIdNavigation,
                    Photos = (ICollection<Photo>)_photoRepository.GetPhotosByIdActorAndPhotoType(x.Id, PhotoTypesConst.Account)
                }).First(x => x.Id == id);

            return query;
        }
    }
}
