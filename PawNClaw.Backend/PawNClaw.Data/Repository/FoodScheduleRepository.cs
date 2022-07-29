using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Repository
{
    public class FoodScheduleRepository : Repository<FoodSchedule>, IFoodScheduleRepository
    {
        public FoodScheduleRepository(ApplicationDbContext db) : base(db)
        {
        }
    }
}
