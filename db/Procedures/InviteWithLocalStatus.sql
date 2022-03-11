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
	Archived,
	dbo.InviteIsLive(DateSent, RefugeeRescinded, HostRescinded, ExpirationDate, AcceptedDate, DateToClose, CompletedDate, Archived) as IsLive,
	dbo.InviteIsActive(DateSent, RefugeeRescinded, HostRescinded, ExpirationDate, AcceptedDate, DateToClose, CompletedDate, Archived) as IsActive,
	dbo.InviteIsRescinded(RefugeeRescinded, HostRescinded) as IsRescinded,
	dbo.InviteIsCompleted(CompletedDate) as IsCompleted
from Invite