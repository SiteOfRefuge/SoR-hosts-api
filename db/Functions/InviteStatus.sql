create function dbo.InviteStatus(@IsArchived bit, @IsCompleted bit, @IsExpired bit, @IsRescinded bit, @HostNumCompleted int, @RefugeeNumCompleted int, 
								  @HostAndRefugeeEnabled bit, @IsActive bit, @IsLive bit, @HostNumActive int, @RefugeeNumActive int)
returns nvarchar(10)
as
begin
	return 
		case when @IsArchived = 1 then 'Archived'
		else
			case when @IsCompleted = 1 then 'Completed'
			else
				case when @IsExpired = 1 or @IsRescinded = 1 or @HostNumCompleted > 0 or @RefugeeNumCompleted > 0 then 'Closed'
				else
					case when @HostAndRefugeeEnabled = 1 then 
						case when @IsActive = 1 then 'Active'
						else --Pending vs. Open
							case when @IsLive = 1 then
								case when @HostNumActive > 0 or @RefugeeNumActive > 0 then 'Pending'
								else 'Open'
								end
							else 'Unknown' --likely an error setting status
							end
						end
					else 'Unknown' --likely an error resetting status, e.g. if host or refugee is disabled but invites weren't rescinded
					end
				end
			end
		end
end;