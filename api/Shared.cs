using System;
using System.Linq;
using System.Reflection;
using System.Security.Claims;
using Microsoft.Azure.Functions.Worker;
using SiteOfRefuge.API.Middleware;

namespace SiteOfRefuge.API
{
    internal class Shared
    {
        internal static bool ValidateUserIdMatchesToken(FunctionContext context, Guid id)
        {
            return true;
            bool validated = false;

            var principalFeature = context.Features.Get<JwtPrincipalFeature>();
            var claimsIdentity = (ClaimsIdentity)principalFeature.Principal.Identity;

            var targetMethod = context.GetTargetFunctionMethod();
            var methodAttributes = targetMethod.GetCustomAttributes<FunctionAuthorizeAttribute>();

            // If there is only the Function[] attribute, no more processing is needed
            if(methodAttributes.Count() > 1)
            {
                var subject = claimsIdentity.Claims.FirstOrDefault( c => c.Type == "sub" ).Value;                        
                if(string.Equals(subject, id.ToString(), StringComparison.OrdinalIgnoreCase))
                    validated = true;
            }
            return validated;
        }
    }
}
