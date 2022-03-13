#nullable disable

using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Net;
using System.Threading.Tasks;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;
using SiteOfRefuge.API.Middleware;
using static SiteOfRefuge.API.SqlShared;

namespace SiteOfRefuge.API
{
    public class AccountApi
    {
        const string PARAM_ID = "@Id";

        [Function(nameof(AccountStatus))]
        //[FunctionAuthorize("subject")]
        public async Task<HttpResponseData> AccountStatus([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "accountstatus/{id}")] HttpRequestData req, Guid id, FunctionContext context)
        {
            var logger = context.GetLogger(nameof(AccountStatus));
            logger.LogInformation("HTTP trigger function processed a request.");

            // TODO: Handle Documented Responses.
            var response = req.CreateResponse(HttpStatusCode.OK);
            if (!Shared.ValidateUserIdMatchesToken(context, id))
            {
                logger.LogInformation($"{context.InvocationId.ToString()} - Expected Id does not match subject claim when checking account status.");
                response.StatusCode = HttpStatusCode.Forbidden;
                return response;
            }

            try
            {
                using (SqlConnection sql = SqlShared.GetSqlConnection())
                {
                    sql.Open();

                    SqlShared.UpdateStatusForAccount(sql, id);
                    AccountStatus status = await SqlShared.GetAccountStatus(sql, id);

                    if (status == SqlShared.AccountStatus.NotFound)
                    {
                        response.StatusCode = HttpStatusCode.NotFound;
                        return response;
                    }

                    Dictionary<string, string> ret = new Dictionary<string, string>();
                    ret.Add("account_status", (status == SqlShared.AccountStatus.Active ? "Active" : "Archived" ));

                    response.StatusCode = HttpStatusCode.OK;
                    await response.WriteAsJsonAsync<Dictionary<string, string>>(ret);
                    return response;
                }
            }
            catch (Exception exc)
            {
                logger.LogInformation(exc.ToString());
                response.StatusCode = HttpStatusCode.BadRequest;
                return response;
            }
        }

        [Function(nameof(ArchiveAccount))]
        //[FunctionAuthorize("subject")]
        public async Task<HttpResponseData> ArchiveAccount([HttpTrigger(AuthorizationLevel.Anonymous, "delete", Route = "account/{id}")] HttpRequestData req, Guid id, FunctionContext context)
        {
            var logger = context.GetLogger(nameof(AccountStatus));
            logger.LogInformation("HTTP trigger function processed a request.");

            // TODO: Handle Documented Responses.
            var response = req.CreateResponse(HttpStatusCode.OK);
            if(!Shared.ValidateUserIdMatchesToken(context, id))
            {
                logger.LogInformation($"{context.InvocationId.ToString()} - Expected Id does not match subject claim when archiving an account.");                    
                response.StatusCode = HttpStatusCode.Forbidden;
                return response;
            }

            try
            {
                //code to copy
                using(SqlConnection sql = SqlShared.GetSqlConnection())
                {
                    sql.Open();
                    using(SqlCommand cmd = new SqlCommand($"exec ArchiveAccount {PARAM_ID}" , sql))
                    {
                        cmd.Parameters.Add(new SqlParameter(PARAM_ID, System.Data.SqlDbType.UniqueIdentifier));
                        cmd.Parameters[PARAM_ID].Value = id;
                        using(SqlDataReader sdr = cmd.ExecuteReader())
                        {
                            while(sdr.Read())
                            {
                                string notifyId = sdr.GetString(0);
                                string accountType = sdr.GetString(1);
                                bool isRefugee = string.Equals(accountType, "Refugee");
                                string sms, email, firstname, lastname;
                                try
                                {
                                    SqlShared.GetContactInfo(sql, id, isRefugee, out sms, out email, out firstname, out lastname);

                                    await Shared.SendNotifications(sms, email, firstname, lastname, "Offer withdrawn! Login at https://siteofrefuge.com to see your invitation.", logger);
                                }
                                catch(Exception exc)
                                {
                                    logger.LogInformation($"{exc.ToString()} - Error getting contact info for notifications.");
                                    response.StatusCode = HttpStatusCode.Forbidden;
                                    return response;
                                }
                                
                                response.StatusCode = HttpStatusCode.BadRequest;
                                await response.WriteStringAsync( $"Error: trying to archive account with Id '{id.ToString()}' but failed.");
                                return response;
                            }
                        }
                    }
                }
            }
            catch(Exception exc)
            {
                logger.LogInformation($"{exc.ToString()} - Error archiving account.");
                response.StatusCode = HttpStatusCode.BadRequest;
                return response;
            }
            response.StatusCode = HttpStatusCode.OK;;
            return response;
        }
    }
}