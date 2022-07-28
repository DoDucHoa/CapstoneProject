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
        public DateTime FromTime { get; set; }
        public DateTime ToTime { get; set; }
        public string Name { get; set; }
        public int CageTypeId { get; set; }
    }
}
