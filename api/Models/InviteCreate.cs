//Not for DB, just for serializing input from request
#nullable disable

using System;

namespace SiteOfRefuge.API.Models
{
    public partial class InviteCreate
    {
        public InviteCreate() {}
        
        internal InviteCreate(Guid refugeeId, Guid hostId, string message)
        {
            this.RefugeeId = refugeeId;
            this.HostId = hostId;
            this.Message = message;
        }

        public Guid RefugeeId { get; set; }
        public Guid HostId { get; set; }
        public string Message { get; set; }
    }    
}