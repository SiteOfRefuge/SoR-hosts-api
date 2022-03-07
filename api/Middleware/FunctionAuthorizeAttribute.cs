using System;
using System.Collections.Generic;

namespace SiteOfRefuge.API.Middleware
{
    /// <summary>
    /// This attribute is used to decorate Function with authorize attribute.
    /// If set, the authorization middleware will validate if this request can be authorized. 
    /// </summary>
    [AttributeUsage(AttributeTargets.Method)]
    public class FunctionAuthorizeAttribute : Attribute
    {
        public FunctionAuthorizeAttribute(string flag)
        {
            Flag = flag;
        }

        public string Flag { get; }
    }
}