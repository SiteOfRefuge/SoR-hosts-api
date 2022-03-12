using System;
using System.Linq;
using System.Reflection;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json.Converters;
using SendGrid;
using SendGrid.Helpers.Mail;
using SiteOfRefuge.API.Middleware;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using Twilio.Types;

namespace SiteOfRefuge.API
{
    internal class Shared
    {
        internal const bool SEND_NOTIFICATIONS = false; //turn this off while debugging to avoid random numbers from sample data getting texts/emails
        internal static async Task SendNotifications(string sms, string email, string firstname, string lastname, string message, ILogger logger = null)
        {
                if(Shared.SEND_NOTIFICATIONS)
                {
                    //only after all the real work is done, notify the recipient of the invite
                    if(!string.IsNullOrEmpty(sms))
                    {
                        if(Shared.SendSMS(sms, message))
                        {
                            if(logger != null) logger.LogInformation("SMS worked!");
                        }
                        else
                            if(logger != null) logger.LogInformation("SMS failed!");
                    }

                    if(!string.IsNullOrEmpty(email))
                    {
                        string name = "SiteOfRefuge Customer";
                        if(!string.IsNullOrEmpty(firstname))
                        {
                            name = firstname;
                            if(!string.IsNullOrEmpty(lastname))
                                name += " " + lastname;
                        }
                        if(await Shared.SendEmailAsync(email, name, message))
                        {
                            if(logger != null) logger.LogInformation("Email sent!");
                        }
                        else
                            if(logger != null) logger.LogInformation("Email failed!");
                    }
                }            
        }

        internal static bool ValidateUserIdMatchesToken(FunctionContext context, Guid id)
        {
            return true;
            var principalFeature = context.Features.Get<JwtPrincipalFeature>();
            var claimsIdentity = (ClaimsIdentity)principalFeature.Principal.Identity;

            var subject = claimsIdentity.Claims.FirstOrDefault( c => c.Type == "sub" ).Value;
            return string.Equals(subject, id.ToString(), StringComparison.OrdinalIgnoreCase);
        }

        internal static bool SendSMS(string to_phone_number, string message)
        {
            string TwilioAccountSid = Environment.GetEnvironmentVariable("TwilioAccountSid");
            string TwilioAuthToken = Environment.GetEnvironmentVariable("TwilioAuthToken");
            string TwilioFromPhone = Environment.GetEnvironmentVariable("TwilioFromPhone");

            TwilioClient.Init(TwilioAccountSid, TwilioAuthToken);
            var to = new PhoneNumber(to_phone_number);
            var from = new PhoneNumber(TwilioFromPhone);
            var msg = MessageResource.Create(
                to: to,
                from: from,
                body: message
            );
            return !string.IsNullOrEmpty(msg.Sid);
        }

        internal static async Task<bool> SendEmailAsync(string to_address, string to_name, string message)
        {
           var apiKey = Environment.GetEnvironmentVariable("SendGridApiKey");
            var email_client = new SendGridClient(apiKey);
            var email_from = new EmailAddress(Environment.GetEnvironmentVariable("EmailFromAddress"), Environment.GetEnvironmentVariable("EmailFromName"));
            var email_subject = "You've received an invitation for shelter!";
            var email_to = new EmailAddress(to_address, to_name);
            var email_plainTextContent = "Visit https://siteofrefuge.com and login to see your invitations.";
            var email_htmlContent = "<strong>Visit https://siteofrefuge.com and login to see your invitations.</strong>";
            var msg = MailHelper.CreateSingleEmail(email_from, email_to, email_subject, email_plainTextContent, email_htmlContent);
            var email_response = await email_client.SendEmailAsync(msg);
            return email_response.IsSuccessStatusCode;
        }
    }

}
