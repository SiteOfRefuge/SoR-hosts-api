create table Invite
(
	RefugeeId uniqueidentifier not null,
	HostId uniqueidentifier not null,
	Message nvarchar(4000),
	DateSent smalldatetime not null,
	RefugeeRescinded smalldatetime,
	HostRescinded smalldatetime,
	ExpirationDate smalldatetime not null,
	AcceptedDate smalldatetime,
	DateToClose smalldatetime,
	CompletedDate smalldatetime,
	HostArchived bit not null default(0),
	RefugeeArchived bit not null default(0),
	CONSTRAINT [PK_Invite] PRIMARY KEY CLUSTERED ( RefugeeId, HostId ),
	CONSTRAINT FK_Invite_Host foreign key(HostId) references Host(Id),
	CONSTRAINT FK_Invite_Refugee foreign key(RefugeeId) references Refugee(Id)
)
