// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

// <auto-generated/>

#nullable disable

using System;

namespace SiteOfRefuge.API.Models
{
    /// <summary> An invitation to connect. </summary>
    public partial class Invite
    {
        public Invite() {}
        
        /// <summary> Initializes a new instance of Invite. </summary>
        /// <param name="refugeeId"> Unique identifier in UUID/GUID format. </param>
        /// <param name="hostId"> Unique identifier in UUID/GUID format. </param>
        internal Invite(Guid refugeeId, Guid hostId)
        {
            RefugeeId = refugeeId;
            HostId = hostId;
        }

        /// <summary> Initializes a new instance of Invite. </summary>
        /// <param name="id"> Unique identifier in UUID/GUID format. </param>
        /// <param name="refugeeId"> Unique identifier in UUID/GUID format. </param>
        /// <param name="hostId"> Unique identifier in UUID/GUID format. </param>
        /// <param name="dateRequested"> Date when inivitation was sent. </param>
        /// <param name="dateAccepted"> Date when inivitation was accepted. </param>
        internal Invite(Guid? id, Guid refugeeId, Guid hostId, DateTimeOffset? dateRequested, DateTimeOffset? dateAccepted)
        {
            Id = id;
            RefugeeId = refugeeId;
            HostId = hostId;
            DateRequested = dateRequested;
            DateAccepted = dateAccepted;
        }

        /// <summary> Unique identifier in UUID/GUID format. </summary>
        public Guid? Id { get; }
        /// <summary> Unique identifier in UUID/GUID format. </summary>
        public Guid RefugeeId { get; }
        /// <summary> Unique identifier in UUID/GUID format. </summary>
        public Guid HostId { get; }
        /// <summary> Date when inivitation was sent. </summary>
        public DateTimeOffset? DateRequested { get; }
        /// <summary> Date when inivitation was accepted. </summary>
        public DateTimeOffset? DateAccepted { get; }
    }
}
