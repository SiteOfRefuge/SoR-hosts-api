create function dbo.InviteIsArchived(@hostArchived bit, @refugeeArchived bit)
returns bit
as
begin
	return 
		case when @hostArchived = 1 or @refugeeArchived = 1 then 1 
		else 0
		end
end;