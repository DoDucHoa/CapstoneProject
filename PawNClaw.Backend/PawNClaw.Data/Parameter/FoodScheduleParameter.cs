using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    class FoodScheduleParameter
    {
        
    }

    public class CreateFoodSchedule
    {
        public TimeSpan FromTime { get; set; }
        public TimeSpan ToTime { get; set; }
        public string Name { get; set; }
        public int CageTypeId { get; set; }
    }
}
