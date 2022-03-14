create view RefugeesWithInviteSummary
as
select 
	r.*,
	case when rStatuses.ActiveInvites is not null then rStatuses.ActiveInvites else 0 end as ActiveInvites,
	case when rStatuses.CompletedInvites is not null then rStatuses.CompletedInvites else 0 end as CompletedInvites,
	case when rStatuses.ClosedInvites is not null then rStatuses.ClosedInvites else 0 end as ClosedInvites,
	case when rStatuses.PendingInvites is not null then rStatuses.PendingInvites else 0 end as PendingInvites,
	case when rStatuses.ArchivedInvites is not null then rStatuses.ArchivedInvites else 0 end as ArchivedInvites
from Refugees r
left outer join 
(
	select 
		RefugeeId,
		sum(case when InviteStatus = 'Active' then 1 else 0 end) as ActiveInvites,
		sum(case when InviteStatus = 'Completed' then 1 else 0 end) as CompletedInvites,
		sum(case when InviteStatus = 'Closed' then 1 else 0 end) as ClosedInvites,
		sum(case when InviteStatus = 'Open' then 1 else 0 end) as OpenInvites,
		sum(case when InviteStatus = 'Pending' then 1 else 0 end) as PendingInvites,
		sum(case when InviteStatus = 'Archived' then 1 else 0 end) as ArchivedInvites
	from InviteWithHostAndRefugeeSummary
	where IsArchived = 0
	group by RefugeeId
) rStatuses
	on r.Id = rStatuses.RefugeeId