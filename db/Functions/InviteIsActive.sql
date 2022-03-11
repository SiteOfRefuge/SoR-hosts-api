create function dbo.InviteIsActive(@dtSent smalldatetime, @dtRefugeeRescinded smalldatetime, @dtHostRescinded smalldatetime, 
	@dtExpiration smalldatetime, @dtAccepted smalldatetime, @dtToClose smalldatetime, @dtCompleted smalldatetime, @hostArchived bit, @refugeeArchived bit)
returns bit
as
begin
	return 
		case when @hostArchived = 1 or @refugeeArchived = 1 then 0
		else
			case when @dtAccepted is null or @dtToClose is null then 0
			else
				case when @dtRefugeeRescinded is not null or @dtHostRescinded is not null then 0
				else
					case when getutcdate() > @dtToClose then 0
					else
						case when @dtCompleted is not null then 0
						else 1 
						end
					end
				end
			end
		end
end;