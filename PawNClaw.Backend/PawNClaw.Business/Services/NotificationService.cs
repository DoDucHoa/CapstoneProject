using FirebaseAdmin.Messaging;
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
            var result = await _message.SendMulticastAsync(message);
            Console.WriteLine("success push notification: " + result);
        }
    }
}
