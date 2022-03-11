create view InviteWithHostAndRefugeeSummary as
select 
	iwls.*,
	HostNumInvites,
	HostNumLive,
	HostNumActive,
	HostNumRescinded,
	HostNumCompleted,
	RefugeeNumInvites,
	RefugeeNumLive,
	RefugeeNumActive,
	RefugeeNumRescinded,
	RefugeeNumCompleted
from InviteWithLocalStatus iwls
join
(
	select 
		HostId, 
		count(*) as HostNumInvites,
		sum(case when IsLive = 1 then 1 else 0 end) as HostNumLive,
		sum(case when IsActive = 1 then 1 else 0 end) as HostNumActive,
		sum(case when IsRescinded = 1 then 1 else 0 end) as HostNumRescinded,
		sum(case when IsCompleted = 1 then 1 else 0 end) as HostNumCompleted
	from InviteWithLocalStatus
	where Archived = 0
	group by HostId
) hAgg
	on iwls.HostId = hAgg.HostId
join
(
	select 
		RefugeeId, 
		count(*) as RefugeeNumInvites,
		sum(case when IsLive = 1 then 1 else 0 end) as RefugeeNumLive,
		sum(case when IsActive = 1 then 1 else 0 end) as RefugeeNumActive,
		sum(case when IsRescinded = 1 then 1 else 0 end) as RefugeeNumRescinded,
		sum(case when IsCompleted = 1 then 1 else 0 end) as RefugeeNumCompleted
	from InviteWithLocalStatus
	where Archived = 0
	group by RefugeeId
) rAgg
	on iwls.RefugeeId = rAgg.RefugeeId