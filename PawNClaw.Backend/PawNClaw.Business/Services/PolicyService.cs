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
                documentDictionaryreturn.Add(documentDictionary.Keys.ToString(), documentDictionary.Values);
            }
            // [END fs_get_all]

            return documentDictionaryreturn;
        }

        public static async Task AddData(string project, string policyId, string newPolicy)
        {
            Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", "pawnclaw-4b6ba-firebase-adminsdk-txxl7-50dcc161a7.json");
            FirestoreDb db = FirestoreDb.Create(project);
            // [START fs_add_data_1]
            DocumentReference docRef = db.Collection("Policy").Document(policyId);
            Dictionary<string, object> policy = new Dictionary<string, object>
            {
                { "policy", newPolicy }
            };
            await docRef.SetAsync(policy);
            // [END fs_add_data_1]
            Console.WriteLine("Added data to the alovelace document in the users collection.");
        }
    }
}
