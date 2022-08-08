using Google.Cloud.Firestore;
using PawNClaw.Data.Const;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class LogsService
    {
        //add log
        public async Task AddLog(ActionLogsParameter data)
        {
            Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", "pawnclaw-4b6ba-firebase-adminsdk-txxl7-50dcc161a7.json");
            FirestoreDb db = FirestoreDb.Create(Const.ProjectFirebaseId);
            // [START fs_add_data_1]

            Query query = db.Collection("ActionLogs");
            QuerySnapshot querySnapshot = await query.GetSnapshotAsync();
            var document = querySnapshot.LongCount() + 1;



            DocumentReference docRef = db.Collection("ActionLogs").Document(document.ToString());
            Dictionary<string, object> log = new Dictionary<string, object>
            {
                { "Id", data.Id },
                { "Type", data.Type},
                { "Target", data.Target },
                { "Name", data.Name },
                { "time", data.Time },
            };
            await docRef.SetAsync(log);
            // [END fs_add_data_1]
        }

        //get logs
        public async Task<List<ActionLogsParameter>> GetLogs(int id, string target)
        {
            Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", "pawnclaw-4b6ba-firebase-adminsdk-txxl7-50dcc161a7.json");
            FirestoreDb db = FirestoreDb.Create(Const.ProjectFirebaseId);

            Query query = db.Collection("ActionLogs");
            QuerySnapshot querySnapshot = await query.GetSnapshotAsync();
            List<ActionLogsParameter> logs = new List<ActionLogsParameter>();
            foreach (DocumentSnapshot snapshot in querySnapshot)
            {
                Dictionary<string, dynamic> log = snapshot.ToDictionary();
                var modificationLog = new ActionLogsParameter()
                {
                    Id = log["Id"],
                    Type = log["Type"],
                    Target = log["Target"],
                    Name = log["Name"],
                    Time = log["Time"],
                };
                logs.Add(modificationLog);
            }
            return logs;
        }
    }
}
