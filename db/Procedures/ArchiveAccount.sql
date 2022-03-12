--returns a list of accounts that need notified their invite was rescinded?
create procedure ArchiveAccount 
	@id uniqueidentifier
as
begin
	declare @isHost bit;
	declare @isRefugee bit;
	select top 1 @isHost = IsHost, @isRefugee = IsRefugee from UserToRefugeeOrHostMapping where Id = @id;

	declare @ret table(Id uniqueidentifier, AccountType nvarchar(10));
	declare @isEnabled bit;

	if(@isHost = 1)
	begin
		set @isEnabled = (select top 1 IsEnabled from Host where Id = @id);
		if(@isEnabled = 1)
		begin
			insert into @ret
			select RefugeeId as Id, 'Refugee' as AccountType from InviteWithLocalStatus where HostId = @id and IsArchived = 0 and (IsActive = 1); --don't need to notify if IsLive = 1

			update Invite
			set HostRescinded = getutcdate()
			from Invite i
			join (		
				select RefugeeId, HostId from InviteWithLocalStatus where HostId = @id and IsArchived = 0 and (IsActive = 1 or IsLive = 1)
			) x
				on i.RefugeeId = x.RefugeeId and i.HostId = x.HostId;

			update Invite set HostArchived = 1 where HostId = @id and HostArchived = 0 and RefugeeArchived = 0;

			update Host set IsEnabled = 0 where Id = @id;
		end
	end

	if(@isRefugee = 1)
	begin
		set @isEnabled = (select top 1 IsEnabled from Refugee where Id = @id);
		if(@isEnabled = 1)
		begin
			insert into @ret
			select HostId as Id, 'Host' as AccountType from InviteWithLocalStatus where RefugeeId = @id and IsArchived = 0 and (IsActive = 1); --don't need to notify if IsLive = 1

			update Invite
			set RefugeeRescinded = getutcdate()
			from Invite i
			join (		
				select RefugeeId, HostId from InviteWithLocalStatus where RefugeeId = @id and IsArchived = 0 and (IsActive = 1 or IsLive = 1)
			) x
				on i.RefugeeId = x.RefugeeId and i.HostId = x.HostId;

			update Invite set RefugeeArchived = 1 where RefugeeId = @id and HostArchived = 0 and RefugeeArchived = 0;

			update Refugee set IsEnabled = 0 where Id = @id;
		end
	end

	select * from @ret;
end