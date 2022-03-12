create view InviteWithHostAndRefugeeSummary as
select
	dbo.InviteStatus(IsArchived, IsCompleted, IsExpired, IsRescinded, HostNumCompleted, RefugeeNumCompleted, 
								  HostAndRefugeeEnabled, IsActive, IsLive, HostNumActive, RefugeeNumActive) as InviteStatus,
	p.*
from
(
	select 
		iwls.*,
		h.IsEnabled as HostIsEnabled,
		r.IsEnabled as RefugeeIsEnabled,
		dbo.AccountsBothEnabled(h.IsEnabled, r.IsEnabled) as HostAndRefugeeEnabled,
		HostNumInvites,
		HostNumLive,
		HostNumActive,
		HostNumExpired,
		HostNumRescinded,
		HostNumCompleted,
		RefugeeNumInvites,
		RefugeeNumLive,
		RefugeeNumExpired,
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
			sum(case when IsExpired = 1 then 1 else 0 end) as HostNumExpired,
			sum(case when IsRescinded = 1 then 1 else 0 end) as HostNumRescinded,
			sum(case when IsCompleted = 1 then 1 else 0 end) as HostNumCompleted
		from InviteWithLocalStatus
		where IsArchived = 0
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
			sum(case when IsExpired = 1 then 1 else 0 end) as RefugeeNumExpired,
			sum(case when IsRescinded = 1 then 1 else 0 end) as RefugeeNumRescinded,
			sum(case when IsCompleted = 1 then 1 else 0 end) as RefugeeNumCompleted
		from InviteWithLocalStatus
		where IsArchived = 0
		group by RefugeeId
	) rAgg
		on iwls.RefugeeId = rAgg.RefugeeId
	join Host h
		on hAgg.HostId = h.Id
	join Refugee r
		on rAgg.RefugeeId = r.Id
) as p