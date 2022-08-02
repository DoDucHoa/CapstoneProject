using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    public class NotificationParameter
    {
        public string content { get; set; }
        public string title { get; set; }
        public long actorId { get; set; }
        public string actorType { get; set; }
        public long targetId { get; set; }
        public string targetType { get; set; }
        public DateTime time { get; set; }
    }
}
