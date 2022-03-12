create procedure UnarchiveAccount 
	@id uniqueidentifier
as
begin
	declare @isHost bit;
	declare @isRefugee bit;
	select top 1 @isHost = IsHost, @isRefugee = IsRefugee from UserToRefugeeOrHostMapping where Id = @id;

	if(@isHost = 1)
	begin
		update Invite set HostArchived = 1 where HostId = @id;
		update Host set IsEnabled = 1 where Id = @id;
	end

	if(@isRefugee = 1)
	begin
		update Invite set RefugeeArchived = 1 where HostId = @id;
		update Refugee set IsEnabled = 1 where Id = @id;
	end
end