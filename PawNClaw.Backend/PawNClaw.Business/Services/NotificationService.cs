﻿using FirebaseAdmin.Messaging;
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
    public class NotificationService
    {
        FirebaseMessaging _message;

        public NotificationService()
        {
            _message = FirebaseMessaging.DefaultInstance;
        }

        public async void SendNoti(List<string> _registrationTokens, Dictionary<string, string> _data, string title, string body)
        {
            var registrationTokens = _registrationTokens;
            var message = new MulticastMessage()
            {
                Data = _data,
                Notification = new Notification
                {
                    Title = title,
                    Body = body
                },

                Tokens = registrationTokens,
            };
            if (_registrationTokens.Any())
            {
                var result = await _message.SendMulticastAsync(message);
                Console.WriteLine("success push notification: " + result);
            }
        }

        public async Task AddNotification(NotificationParameter data)
        {
            Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", "pawnclaw-4b6ba-firebase-adminsdk-txxl7-50dcc161a7.json");
            FirestoreDb db = FirestoreDb.Create(Const.ProjectFirebaseId);
            // [START fs_add_data_1]

            Query query = db.Collection("Notification");
            QuerySnapshot querySnapshot = await query.GetSnapshotAsync();
            var document = querySnapshot.LongCount() + 1;



            DocumentReference docRef = db.Collection("Notification").Document(document.ToString());
            Dictionary<string, object> notification = new Dictionary<string, object>
            {
                { "actorId", data.actorId },
                { "actorType", data.actorType },
                { "targetId", data.targetId },
                { "targetType", data.targetType },
                { "time", Timestamp.FromDateTime(data.time.ToUniversalTime())},
                { "title", data.title },
                { "content", data.content },
                { "seen", false }
            };
            await docRef.SetAsync(notification);
            // [END fs_add_data_1]
        }

        public async Task SeenAll(int id, string target)
        {
            Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", "pawnclaw-4b6ba-firebase-adminsdk-txxl7-50dcc161a7.json");
            FirestoreDb db = FirestoreDb.Create(Const.ProjectFirebaseId);

            Query query = db.Collection("Notification").WhereEqualTo("targetId", id).WhereEqualTo("targetType", target).WhereEqualTo("seen", false);
            QuerySnapshot querySnapshot = await query.GetSnapshotAsync();
            Dictionary<string, object> updates = new Dictionary<string, object>
            {
                { "seen", true }
            };
            foreach (DocumentSnapshot snapshot in querySnapshot)
            {
                await snapshot.Reference.UpdateAsync(updates);
            }
        }

        public async Task<List<NotificationParameter>> GetNotis(int id, string target)
        {
            Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", "pawnclaw-4b6ba-firebase-adminsdk-txxl7-50dcc161a7.json");
            FirestoreDb db = FirestoreDb.Create(Const.ProjectFirebaseId);

            Query query = db.Collection("Notification").WhereEqualTo("targetId", id).WhereEqualTo("targetType", target);
            QuerySnapshot querySnapshot = await query.GetSnapshotAsync();
            List<NotificationParameter> notifications = new List<NotificationParameter>();
            foreach (DocumentSnapshot snapshot in querySnapshot)
            {
                Dictionary<string, dynamic> noti = snapshot.ToDictionary();
                Timestamp timestamp = (Timestamp)noti["time"];
                var notification = new NotificationParameter()
                {
                    actorId = noti["actorId"],
                    actorType = noti["actorType"],
                    targetId = noti["targetId"],
                    targetType = noti["targetType"],
                    time = timestamp.ToDateTime(),
                    content = noti["content"],
                    title = noti["title"],
                    seen = noti["seen"]
                };
                notifications.Add(notification);
            }
            return notifications;
        }
    }
}
