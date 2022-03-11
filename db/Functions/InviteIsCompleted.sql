create function dbo.InviteIsCompleted(@dtCompleted smalldatetime)
returns bit
as
begin
	return 
		case when @dtCompleted is not null then 1 
		else 0 end
end;
