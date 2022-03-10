using System;
using System.Linq;
using System.Reflection;
using System.Security.Claims;
using System.Text;
using Microsoft.Azure.Functions.Worker;
using Newtonsoft.Json.Converters;
using SiteOfRefuge.API.Middleware;

namespace SiteOfRefuge.API
{
    internal class Shared
    {
        internal static string FixUnicodeGibberish(string s)
        {
            byte[] bytes = Encoding.Default.GetBytes(s);
            return Encoding.UTF8.GetString(bytes);
        }
        internal static bool ValidateUserIdMatchesToken(FunctionContext context, Guid id)
        {
            return true;
            var principalFeature = context.Features.Get<JwtPrincipalFeature>();
            var claimsIdentity = (ClaimsIdentity)principalFeature.Principal.Identity;

            var subject = claimsIdentity.Claims.FirstOrDefault( c => c.Type == "sub" ).Value;
            return string.Equals(subject, id.ToString(), StringComparison.OrdinalIgnoreCase);
        }

        public class CustomDateTimeConverter : IsoDateTimeConverter
        {
            public CustomDateTimeConverter()
            {
                base.DateTimeFormat = "yyyy-MM-dd";
            }
        }    
    }

}
