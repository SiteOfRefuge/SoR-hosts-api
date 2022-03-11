create function dbo.InviteIsRescinded(@dtRefugeeRescinded smalldatetime, @dtHostRescinded smalldatetime)
returns bit
as
begin
	return 
		case when @dtRefugeeRescinded is not null then 1 
		else 
			case when @dtHostRescinded is not null then 1
			else 0 end
		end
end;