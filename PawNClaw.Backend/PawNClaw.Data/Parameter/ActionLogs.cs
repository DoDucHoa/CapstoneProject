using Google.Cloud.Firestore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Parameter
{
    public class ActionLogsParameter
    {
        public long Id { get; set; }
        public string Target { get; set; }
        public string Name { get; set; }
        public string Type { get; set; }
        public Timestamp Time { get; set; }
    }
}
