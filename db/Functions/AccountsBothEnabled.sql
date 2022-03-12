create function dbo.AccountsBothEnabled(@hostIsEnabled bit, @refugeeIsEnabled bit)
returns bit
as
begin
	return 
		case when @hostIsEnabled = 1 and @refugeeIsEnabled = 1 then 1 
		else 0 end
end;