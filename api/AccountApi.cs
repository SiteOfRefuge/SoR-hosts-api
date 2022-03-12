#nullable disable

using System;
using System.Data.SqlClient;
using System.Net;
using System.Threading.Tasks;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;
using SiteOfRefuge.API.Middleware;

namespace SiteOfRefuge.API
{
    public class AccountApi
    {
        [Function(nameof(AccountStatus))]
        //[FunctionAuthorize("subject")]
        public async Task<HttpResponseData> AccountStatus([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "accountstatus/{id}")] HttpRequestData req, Guid id, FunctionContext context)
        {
            var logger = context.GetLogger(nameof(AccountStatus));
            logger.LogInformation("HTTP trigger function processed a request.");

            // TODO: Handle Documented Responses.
            var response = req.CreateResponse(HttpStatusCode.OK);
            if(!Shared.ValidateUserIdMatchesToken(context, id))
            {
                logger.LogInformation($"{context.InvocationId.ToString()} - Expected refugee Id does not match subject claim when creating a new refugee.");                    
                response.StatusCode = HttpStatusCode.Forbidden;
                return response;
            }
            //code to copy
            /*
            using(SqlConnection sql = SqlShared.GetSqlConnection())
            {
                sql.Open();
                using(SqlCommand cmd = new SqlCommand($"select top 1 * from Refugee where Id = {PARAM_REFUGEE_ID}" , sql))
                {
                    cmd.Parameters.Add(new SqlParameter(PARAM_REFUGEE_ID, System.Data.SqlDbType.UniqueIdentifier));
                    cmd.Parameters[PARAM_REFUGEE_ID].Value = refugee.Id;
                    using(SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        if(sdr.Read())
                        {
                            response.StatusCode = HttpStatusCode.BadRequest;
                            await response.WriteStringAsync( $"Error: trying to create a refugee with Id '{refugee.Id.ToString()}' but a refugee with this Id already exists in the database.");
                            return response;
                        }
                    }
                }
            }
            */

            throw new NotImplementedException();
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
            //code to copy
            /*
            using(SqlConnection sql = SqlShared.GetSqlConnection())
            {
                sql.Open();
                using(SqlCommand cmd = new SqlCommand($"select top 1 * from Refugee where Id = {PARAM_REFUGEE_ID}" , sql))
                {
                    cmd.Parameters.Add(new SqlParameter(PARAM_REFUGEE_ID, System.Data.SqlDbType.UniqueIdentifier));
                    cmd.Parameters[PARAM_REFUGEE_ID].Value = refugee.Id;
                    using(SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        if(sdr.Read())
                        {
                            response.StatusCode = HttpStatusCode.BadRequest;
                            await response.WriteStringAsync( $"Error: trying to create a refugee with Id '{refugee.Id.ToString()}' but a refugee with this Id already exists in the database.");
                            return response;
                        }
                    }
                }
            }
            */

            throw new NotImplementedException();
        }
    }
}