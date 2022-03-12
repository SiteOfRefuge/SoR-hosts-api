create procedure UpdateStatus 
	@id uniqueidentifier
as
begin
	--expiration case: no data change needed, just check expirationdate in functions for if invite is live, [active - not used here], or expired
	--complete case: set invite completeddate, archive both accounts
	declare @hostId uniqueidentifier; -- should just be 1 new completed for that user...
	declare @refugeeId uniqueidentifier;

	select top 1 @hostId = HostId, @refugeeId = RefugeeId from Invite where (HostId = @id or RefugeeId = @id) and DateToClose is not null and getutcdate() > DateToClose and HostRescinded is null and RefugeeRescinded is null and completeddate is null and hostarchived = 0 and refugeearchived = 0;
	if(@hostId is not null and @refugeeId is not null)
	begin
		update Invite set CompletedDate = getutcdate() where HostId = @hostId and RefugeeId = @refugeeId;
	end

	exec ArchiveAccount @hostId;
	exec ArchiveAccount @refugeeId;
end