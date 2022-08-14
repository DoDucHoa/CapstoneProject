using Google.Cloud.Firestore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class PolicyService
    {
        public static async Task<Dictionary<string, object>> GetAllPolicy(string project)
        {
            // [START fs_initialize_project_id]
            Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", "pawnclaw-4b6ba-firebase-adminsdk-txxl7-50dcc161a7.json");
            FirestoreDb db = FirestoreDb.Create(project);
            // [END fs_initialize_project_id]

            // [START fs_get_all]
            CollectionReference policyReference = db.Collection("Policy");
            QuerySnapshot snapshot = await policyReference.GetSnapshotAsync();
            Dictionary<string, object> documentDictionaryreturn = new Dictionary<string, object>();
            foreach (DocumentSnapshot document in snapshot.Documents)
            {
                Console.WriteLine("Id: {0} ", document.Id);
                Dictionary<string, object> documentDictionary = document.ToDictionary();
                Console.WriteLine("Policy: {0}", documentDictionary["policy"]);
                Console.WriteLine();
                documentDictionaryreturn.Add(document.Id, documentDictionary.Values);
            }
            // [END fs_get_all]

            return documentDictionaryreturn;
        }

        public static async Task<Dictionary<string, object>> GetCustomerPolicy(string project)
        {
            // [START fs_initialize_project_id]
            Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", "pawnclaw-4b6ba-firebase-adminsdk-txxl7-50dcc161a7.json");
            FirestoreDb db = FirestoreDb.Create(project);
            // [END fs_initialize_project_id]

            // [START fs_get_all]
            DocumentReference policyReference = db.Collection("Policy").Document("CustomerPolicy");
            DocumentSnapshot snapshot = await policyReference.GetSnapshotAsync();
            Dictionary<string, object> documentDictionary = snapshot.ToDictionary();
            // [END fs_get_all]

            return documentDictionary;
        }

        public static async Task AddData(string project, string newPolicy)
        {
            Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", "pawnclaw-4b6ba-firebase-adminsdk-txxl7-50dcc161a7.json");
            FirestoreDb db = FirestoreDb.Create(project);
            // [START fs_add_data_1]
            DocumentReference docRef = db.Collection("Policy").Document("MainPolicy");
            Dictionary<string, object> policy = new Dictionary<string, object>
            {
                { "policy", newPolicy }
            };
            await docRef.SetAsync(policy);
            // [END fs_add_data_1]
        }

        public static async Task UpdateCustomerPolicy(string project, string newPolicy)
        {
            Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", "pawnclaw-4b6ba-firebase-adminsdk-txxl7-50dcc161a7.json");
            FirestoreDb db = FirestoreDb.Create(project);
            // [START fs_add_data_1]
            DocumentReference docRef = db.Collection("Policy").Document("CustomerPolicy");
            Dictionary<string, object> policy = new Dictionary<string, object>
            {
                { "policy", newPolicy }
            };
            await docRef.SetAsync(policy);
            // [END fs_add_data_1]
        }

        public static async Task<Dictionary<string, object>> GetPolicy(string project)
        {
            // [START fs_initialize_project_id]
            Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", "pawnclaw-4b6ba-firebase-adminsdk-txxl7-50dcc161a7.json");
            FirestoreDb db = FirestoreDb.Create(project);
            // [END fs_initialize_project_id]

            DocumentReference policy = db.Collection("Policy").Document("MainPolicy");
            DocumentSnapshot snapshot = await policy.GetSnapshotAsync();
            if (snapshot.Exists)
            {
                Dictionary<string, object> policyDic = snapshot.ToDictionary();
                return policyDic;
            }
            else
            {
                throw new Exception("Document "+ snapshot.Id + " does not exist!");
            }
        }

    }
}
