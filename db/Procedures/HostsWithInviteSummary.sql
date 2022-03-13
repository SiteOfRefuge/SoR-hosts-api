create view HostsWithInviteSummary
as
select 
	h.*,
	case when hStatuses.ActiveInvites is not null then hStatuses.ActiveInvites else 0 end as ActiveInvites,
	case when hStatuses.CompletedInvites is not null then hStatuses.CompletedInvites else 0 end as CompletedInvites,
	case when hStatuses.ClosedInvites is not null then hStatuses.ClosedInvites else 0 end as ClosedInvites,
	case when hStatuses.PendingInvites is not null then hStatuses.PendingInvites else 0 end as PendingInvites,
	case when hStatuses.ArchivedInvites is not null then hStatuses.ArchivedInvites else 0 end as ArchivedInvites
from Hosts h
left outer join 
(
	select 
		HostId,
		sum(case when InviteStatus = 'Active' then 1 else 0 end) as ActiveInvites,
		sum(case when InviteStatus = 'Completed' then 1 else 0 end) as CompletedInvites,
		sum(case when InviteStatus = 'Closed' then 1 else 0 end) as ClosedInvites,
		sum(case when InviteStatus = 'Pending' then 1 else 0 end) as PendingInvites,
		sum(case when InviteStatus = 'Archived' then 1 else 0 end) as ArchivedInvites
	from InviteWithHostAndRefugeeSummary
	where IsArchived = 0
	group by HostId
) hStatuses
	on h.Id = hStatuses.HostId