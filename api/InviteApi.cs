// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

// <auto-generated/>

#nullable disable

using System;
using System.IO;
using System.Net;
using System.Threading.Tasks;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;
using SiteOfRefuge.API.Models;

using Twilio;
using Twilio.Rest.Api.V2010.Account;
using Twilio.Types;

using SendGrid;
using SendGrid.Helpers.Mail;
using System.Data.SqlClient;

namespace SiteOfRefuge.API
{
    public class InviteApi
    {

        /// <summary> Initializes a new instance of InviteApi. </summary>
        public InviteApi() {}

        /// <summary> Lists any current invitation requests for this user. </summary>
        /// <param name="req"> Raw HTTP Request. </param>
        [Function(nameof(GetInvites))]
        public HttpResponseData GetInvites([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "invite")] HttpRequestData req, FunctionContext context)
        {
            var logger = context.GetLogger(nameof(GetInvites));
            logger.LogInformation("HTTP trigger function processed a request.");

            // TODO: Handle Documented Responses.
            // Spec Defines: HTTP 200
            // Spec Defines: HTTP 403
            // Spec Defines: HTTP 404

            throw new NotImplementedException();
        }

        /// <summary> Invite a refugee to connect. </summary>
        /// <param name="body"> The Id to use. </param>
        /// <param name="req"> Raw HTTP Request. </param>
        [Function(nameof(InviteRefugeeAsync))]
        public async Task<HttpResponseData> InviteRefugeeAsync([HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "invite")]  HttpRequestData req, FunctionContext context)
        {
            var logger = context.GetLogger(nameof(InviteRefugeeAsync));
            logger.LogInformation("HTTP trigger function processed a request.");
            

            InviteCreate invite = null;
            var response = req.CreateResponse(HttpStatusCode.OK);

            try
            {
                if (req.Body is not null)
                { 
                    try
                    {
                        var reader = new StreamReader(req.Body);
                        var respBody = await reader.ReadToEndAsync();
                        invite = Newtonsoft.Json.JsonConvert.DeserializeObject<InviteCreate>(respBody);
                        //refugee.Summary.Possession_Date = DateTime.Parse(JObject.Parse(respBody)["summary"]["possession_date"].ToString());
                    }
                    catch(Exception exc)
                    {
                        logger.LogInformation($"{context.InvocationId.ToString()} - Error deserializing Invite object. Err: {exc.Message}");
                        response.StatusCode = HttpStatusCode.BadRequest;
                        return response;
                    }
                }
                
                if(!Shared.ValidateUserIdMatchesToken(context, invite.HostId))
                {
                    logger.LogInformation($"{context.InvocationId.ToString()} - Expected host Id does not match subject claim when creating a new invite.");                    
                    response.StatusCode = HttpStatusCode.Forbidden;
                    return response;
                }

                //TODO: not implemented yet, but need to update invite statuses to ensure not doing something bad
                SqlShared.UpdateInvitationStatusForHost();
                SqlShared.UpdateInvitationStatusForRefugee();

                if(!SqlShared.CanInviteBeSent(invite.HostId, invite.RefugeeId))
                {
                    logger.LogInformation($"Invite would violate policy: {invite.HostId}, {invite.RefugeeId}");
                    response.StatusCode = HttpStatusCode.Forbidden;
                    return response;
                }

                const string PARAM_REFUGEE_ID = "@RefugeeId";
                const string PARAM_HOST_ID = "@HostId";
                const string PARAM_MESSAGE = "@Message";
                string sms = null;
                string email = null;
                string firstname = null;
                string lastname = null;
                using(SqlConnection sql = SqlShared.GetSqlConnection())
                {
                    sql.Open();

                    try
                    {
                        using(SqlCommand cmd = new SqlCommand($@"
                            declare @dt smalldatetime;
                            set @dt = getutcdate();
                            select @dt, dateadd(d, 2, @dt);
                            insert into Invite(RefugeeId, HostId, Message, DateSent, ExpirationDate) 
                            values({PARAM_REFUGEE_ID}, {PARAM_HOST_ID}, {PARAM_MESSAGE}, @dt, dateadd(d, 2, @dt));", sql))
                        {
                            cmd.Parameters.Add(new SqlParameter(PARAM_REFUGEE_ID, System.Data.SqlDbType.UniqueIdentifier));
                            cmd.Parameters[PARAM_REFUGEE_ID].Value = invite.RefugeeId;
                            cmd.Parameters.Add(new SqlParameter(PARAM_HOST_ID, System.Data.SqlDbType.UniqueIdentifier));
                            cmd.Parameters[PARAM_HOST_ID].Value = invite.HostId;
                            cmd.Parameters.Add(new SqlParameter(PARAM_MESSAGE, System.Data.SqlDbType.NVarChar));
                            cmd.Parameters[PARAM_MESSAGE].Value = invite.Message;

                            cmd.ExecuteNonQuery();
                        }
                    }
                    catch(Exception exc)
                    {
                        logger.LogInformation($"{exc.ToString()} - Error inserting invite into database.");
                        response.StatusCode = HttpStatusCode.Forbidden;
                        return response;
                    }

                    try
                    {
                        SqlShared.GetContactInfo(sql, invite.RefugeeId, true, out sms, out email, out firstname, out lastname);
                    }
                    catch(Exception exc)
                    {
                        logger.LogInformation($"{exc.ToString()} - Error getting contact info for notifications.");
                        response.StatusCode = HttpStatusCode.Forbidden;
                        return response;
                    }
                }

                //SEND NOTIFICATIONS
                Shared.SendNotifications(sms, email, firstname, lastname, "You've been offered shelter! Login at https://siteofrefuge.com to see your invitation.", logger);
            }
            catch(Exception exc)
            {
                logger.LogInformation($"{exc.ToString()} - Error sending invite.");
                response.StatusCode = HttpStatusCode.BadRequest;
                return response;
            }

            return response;
        }

        /// <summary> Show an invitation. </summary>
        /// <param name="req"> Raw HTTP Request. </param>
        /// <param name="id"> Invite id in UUID/GUID format. </param>
        [Function(nameof(GetInvite))]
        public HttpResponseData GetInvite([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "invite/{id}")] HttpRequestData req, string id, FunctionContext context)
        {
            var logger = context.GetLogger(nameof(GetInvite));
            logger.LogInformation("HTTP trigger function processed a request.");

            // TODO: Handle Documented Responses.
            // Spec Defines: HTTP 200
            // Spec Defines: HTTP 403
            // Spec Defines: HTTP 404

            throw new NotImplementedException();
        }

        /// <summary> Accept an invitation to connect. </summary>
        /// <param name="id"> Invite id in UUID/GUID format. </param>
        /// <param name="body"> The Id to use. </param>
        /// <param name="req"> Raw HTTP Request. </param>
        [Function(nameof(AcceptInvitation))]
        public HttpResponseData AcceptInvitation(string id, [HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "invite/{id}")] string body, HttpRequestData req, FunctionContext context)
        {
            var logger = context.GetLogger(nameof(AcceptInvitation));
            logger.LogInformation("HTTP trigger function processed a request.");

            // TODO: Handle Documented Responses.
            // Spec Defines: HTTP 204
            // Spec Defines: HTTP 403
            // Spec Defines: HTTP 404

            throw new NotImplementedException();
        }

        /// <summary> Withdraw invitation request. </summary>
        /// <param name="req"> Raw HTTP Request. </param>
        /// <param name="id"> Invite id in UUID/GUID format. </param>
        [Function(nameof(DeleteInvite))]
        public HttpResponseData DeleteInvite([HttpTrigger(AuthorizationLevel.Anonymous, "delete", Route = "invite/{id}")] HttpRequestData req, Guid refugeeId, Guid hostId, FunctionContext context)
        {
            var logger = context.GetLogger(nameof(DeleteInvite));
            logger.LogInformation("HTTP trigger function processed a request.");

            var response = req.CreateResponse(HttpStatusCode.OK);

            if(!Shared.ValidateUserIdMatchesToken(context, refugeeId) && !Shared.ValidateUserIdMatchesToken(context, hostId))
            {
                logger.LogInformation($"{context.InvocationId.ToString()} - Expected refugee Id and host Id do not match subject claim when deleting an invite.");                    
                response.StatusCode = HttpStatusCode.Forbidden;
                return response;
            }


            // TODO: Handle Documented Responses.
            // Spec Defines: HTTP 200
            // Spec Defines: HTTP 404

            throw new NotImplementedException();
        }
    }
}
