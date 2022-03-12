create view InviteWithLocalStatus as
select 
	RefugeeId,
	HostId, 
	Message,
	DateSent,
	RefugeeRescinded,
	HostRescinded,
	ExpirationDate,
	AcceptedDate,
	DateToClose,
	CompletedDate,
	HostArchived,
	RefugeeArchived,
	dbo.InviteIsLive(DateSent, RefugeeRescinded, HostRescinded, ExpirationDate, AcceptedDate, DateToClose, CompletedDate, HostArchived, RefugeeArchived) as IsLive,
	dbo.InviteIsActive(DateSent, RefugeeRescinded, HostRescinded, ExpirationDate, AcceptedDate, DateToClose, CompletedDate, HostArchived, RefugeeArchived) as IsActive,
	dbo.InviteIsExpired(RefugeeRescinded, HostRescinded, ExpirationDate, AcceptedDate, DateToClose, CompletedDate, HostArchived, RefugeeArchived) as IsExpired,
	dbo.InviteIsRescinded(RefugeeRescinded, HostRescinded) as IsRescinded,
	dbo.InviteIsCompleted(CompletedDate) as IsCompleted,
	dbo.InviteIsArchived(HostArchived, RefugeeArchived) as IsArchived
from Invite