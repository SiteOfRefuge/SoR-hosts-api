create function dbo.InviteIsLive(@dtSent smalldatetime, @dtRefugeeRescinded smalldatetime, @dtHostRescinded smalldatetime, 
	@dtExpiration smalldatetime, @dtAccepted smalldatetime, @dtToClose smalldatetime, @dtCompleted smalldatetime, @hostArchived bit, @refugeeArchived bit)
returns bit
as
begin
	return 
		case when @hostArchived = 1 or @refugeeArchived = 1 then 0
		else
			case when @dtAccepted is not null or @dtToClose is not null then 0
			else
				case when @dtRefugeeRescinded is not null or @dtHostRescinded is not null then 0
				else
					case when @dtCompleted is not null then 0
					else 
						case when getutcdate() <= @dtExpiration then 1
						else 0 end
					end
				end
			end
		end
end;