create function dbo.InviteIsExpired(@dtRefugeeRescinded smalldatetime, @dtHostRescinded smalldatetime, 
	@dtExpiration smalldatetime, @dtAccepted smalldatetime, @dtToClose smalldatetime, @dtCompleted smalldatetime, @hostArchived bit, @refugeeArchived bit)
returns bit
as
begin
	return 
		case when @hostArchived = 1 or @refugeeArchived = 1 then 0 --this is the host or refugee archiving the invite, not the account being archived
		else
			case when @dtAccepted is not null or @dtToClose is not null then 0
			else
				case when @dtRefugeeRescinded is not null or @dtHostRescinded is not null then 0
				else
					case when @dtCompleted is not null then 0
					else 
						case when getutcdate() > @dtExpiration then 1
							--what about if account got archived manually before this? archive all invites at this time too! so won't be a problem
						else 0 end
					end
				end
			end
		end
end;