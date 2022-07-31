using Google.Cloud.Firestore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class ConstService
    {
        public static async Task AddData(string project, string collection, string document, int newData)
        {
            Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", "pawnclaw-4b6ba-firebase-adminsdk-txxl7-50dcc161a7.json");
            FirestoreDb db = FirestoreDb.Create(project);
            // [START fs_add_data_1]
            DocumentReference docRef = db.Collection(collection).Document(document);
            Dictionary<string, object> policy = new Dictionary<string, object>
            {
                { "data", newData }
            };
            await docRef.SetAsync(policy);
            // [END fs_add_data_1]
        }

        public static async Task<Dictionary<string, object>> Get(string project, string collection, string document)
        {
            // [START fs_initialize_project_id]
            Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", "pawnclaw-4b6ba-firebase-adminsdk-txxl7-50dcc161a7.json");
            FirestoreDb db = FirestoreDb.Create(project);
            // [END fs_initialize_project_id]

            DocumentReference policy = db.Collection(collection).Document(document);
            DocumentSnapshot snapshot = await policy.GetSnapshotAsync();
            if (snapshot.Exists)
            {
                Dictionary<string, object> policyDic = snapshot.ToDictionary();
                return policyDic;
            }
            else
            {
                throw new Exception("Document " + snapshot.Id + " does not exist!");
            }
        }
    }
}
