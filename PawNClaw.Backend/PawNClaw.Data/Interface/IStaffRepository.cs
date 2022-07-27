using PawNClaw.Data.Database;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Interface
{
    public interface IStaffRepository : IRepository<Staff>
    {
        public Staff GetStaffWithAccount(int staffId);
        public bool UpdateStaffById(UpdateStaffParameter updateStaffParameter);
    }
}
