using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Middleware;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Security.Claims;
using System.Threading.Tasks;

namespace SiteOfRefuge.API.Middleware
{
    /// <summary>
    /// Authorization middleware.
    /// </summary>
    public class AuthorizationMiddleware
        : IFunctionsWorkerMiddleware
    {
        private readonly ILogger<AuthorizationMiddleware> logger;

        public AuthorizationMiddleware(ILogger<AuthorizationMiddleware> logger)
        {
            this.logger = logger;
        }
        public async Task Invoke(FunctionContext context, FunctionExecutionDelegate next)
        {
            if (context.IsHttpTriggerFunction())
            {
                var principalFeature = context.Features.Get<JwtPrincipalFeature>();
                var claimsIdentity = (ClaimsIdentity)principalFeature.Principal.Identity;
                
                // TODO: We can use the authorization framework to create custom validation, like roles or
                //       to verify that the subject (sub) claim matches the route path for the Guid.
                var targetMethod = context.GetTargetFunctionMethod();
                var methodAttributes = targetMethod.GetCustomAttributes<FunctionAuthorizeAttribute>();

                // If there is only the Function[] attribute, no more processing is needed
                if( methodAttributes.Count() > 1)
                {
                    var flag = methodAttributes.FirstOrDefault().Flag;

                    var subject = claimsIdentity.Claims.FirstOrDefault( c => c.Type == "sub" ).Value;                        

                    // [FunctionAuthorize("subject")] decorator
                    if( string.Equals( flag, "subject", StringComparison.OrdinalIgnoreCase) )
                    {
                        try
                        {
                            var id = context.BindingContext.BindingData["id"] as string;

                            if( !string.Equals( subject, id, StringComparison.OrdinalIgnoreCase) )
                            {
                                // If the Subject and route path do not match the same id, we should send back a 403. 
                                logger.LogInformation( $"{context.InvocationId.ToString()} - Subject claim ({subject}) does not match resource id ({id})");                
                                await context.CreateJsonResponse(System.Net.HttpStatusCode.Forbidden, new { Message = "Subject claim does not match resource id" });
                                return;
                            }
                        }
                        catch( InvalidOperationException )
                        {
                            // If there is no subject claim, kill the request
                            logger.LogInformation( $"{context.InvocationId.ToString()} - Malformed bearer token. Subject claim missing.");                
                            await context.CreateJsonResponse(System.Net.HttpStatusCode.Unauthorized, new { Message = "Malformed bearer token" });
                            return;
                        }
                    } 
                    else if( string.Equals( flag, "admin", StringComparison.OrdinalIgnoreCase) )
                    {
                        // [FunctionAuthorize("subject")] decorator
                        try
                        {
                            bool isAdmin = false;
                            
                            bool.TryParse( claimsIdentity.Claims.FirstOrDefault( c => c.Type == "extension_SORadmin" ).Value, out isAdmin );
                            
                            if( !isAdmin ) {
                                logger.LogInformation( $"{context.InvocationId.ToString()} - Subject ({subject}) does not have admin privs");                
                                await context.CreateJsonResponse(System.Net.HttpStatusCode.Forbidden, new { Message = "Requires admin privs" });
                                return;
                            }
                        }
                        catch( InvalidOperationException )
                        {
                            // If there is no subject claim, kill the request
                            logger.LogInformation( $"{context.InvocationId.ToString()} - Malformed bearer token. Subject claim missing.");                
                            await context.CreateJsonResponse(System.Net.HttpStatusCode.Unauthorized, new { Message = "Malformed bearer token" });
                            return;
                        }
                    }
                } 

                await next(context);
            }
            else
            {
                await next(context);
            }
        }

    }
}