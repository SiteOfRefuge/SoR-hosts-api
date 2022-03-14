create view Hosts as
with contacts as
(
	select ContactId, ContactModeId, ContactMethod, ContactValue, IsVerified from
	(
		select 
		ctm.ContactId,
		cm.Id as ContactModeId,
		cmm.value as ContactMethod,
		cm.Value as ContactValue,
		cm.verified as IsVerified,
		row_number() over (partition by ctm.ContactId, cmm.value order by cm.id asc) as rownum
		from contacttomethods ctm
		join contactmode cm on ctm.contactmodeid = cm.id
		join contactmodemethod cmm on cm.method = cmm.id
	) as cInner
	where cInner.rownum = 1 
), languages as 
(
	select * from (
		select hstl.HostSummaryId, sl.value as Language,
		row_number() over (partition by hstl.HostSummaryId, sl.id order by sl.id asc) as rownum
		from hostsummarytolanguages hstl
		join spokenlanguages sl on hstl.spokenlanguagesid = sl.id	
	) lInner
	where lInner.rownum = 1
), restrictionstmp as (
	select Restriction, HostSummaryId from (
		select r.value as Restriction,
			hstr.HostSummaryId,
			row_number() over (partition by hstr.HostSummaryId, r.id order by r.id asc) as rownum
            from hostsummarytorestrictions hstr
            join Restrictions r on hstr.restrictionsid = r.id
	) rInner
	where rInner.rownum = 1
)
select 
	h.id as Id,
	h.IsEnabled as IsEnabled,
	hs.id as HostSummaryId,
	hs.Region as HostSummaryRegion,
	hs.AllowedPeople as HostSummaryPeople,
	hs.Message as HostSummaryMessage,
	hs.Shelter as HostSummaryShelter,
	hs.Availability as HostSummaryAvailabilityId,
	a.DateAvailable as AvailabilityDateAvailable,
	a.Active as AvailabilityActive,
	alos.value as AvailabilityLengthOfStayValue,
	c.Id as HostContactId,
	c.FirstName as HostContactFirstName,
	c.LastName as HostContactLastName,
	--cmSMS.ContactModeId as SMSId, 
	cmSMS.ContactMethod as SMSContactMethod, 
	cmSMS.ContactValue as SMSContactValue, 
	cmSMS.IsVerified as SMSIsVerified,
	--cmPhone.ContactModeId as PhoneId, 
	cmPhone.ContactMethod as PhoneContactMethod, 
	cmPhone.ContactValue as PhoneContactValue, 
	cmPhone.IsVerified as PhoneIsVerified,
	--cmEmail.ContactModeId as EmailId, 
	cmEmail.ContactMethod as EmailContactMethod, 
	cmEmail.ContactValue as EmailContactValue, 
	cmEmail.IsVerified as EmailIsVerified,
	case when lEnglish.Language is not null then 1 else 0 end as English,
	case when lUkrainian.Language is not null then 1 else 0 end as Ukrainian,
	case when lPolish.Language is not null then 1 else 0 end as Polish,
	case when lRussian.Language is not null then 1 else 0 end as Russian,
	case when lSlovak.Language is not null then 1 else 0 end as Slovak,
	case when lHungarian.Language is not null then 1 else 0 end as Hungarian,
	case when lRomanian.Language is not null then 1 else 0 end as Romanian,
	case when lOther.Language is not null then 1 else 0 end as Other,
	case when rKids.Restriction is not null then 1 else 0 end as Kids,
	case when rMen.Restriction is not null then 1 else 0 end as Men,
	case when rWomen.Restriction is not null then 1 else 0 end as Women,
	case when rDogs.Restriction is not null then 1 else 0 end as Dogs,
	case when rCats.Restriction is not null then 1 else 0 end as Cats,
	case when rOtherPets.Restriction is not null then 1 else 0 end as OtherPets
from host h
join hostsummary hs 
    on h.summary = hs.id
join availability a
    on hs.availability = a.id
left outer join AvailabilityLengthOfStay alos
    on a.LengthOfStay = alos.Id
join contact c 
    on h.contact = c.id
left outer join (
	select * from contacts where contactmethod = 'SMS'
) cmSMS
	on cmSMS.ContactId = c.Id
left outer join (
	select * from contacts where contactmethod = 'Phone'
) cmPhone
	on cmPhone.ContactId = c.Id
left outer join (
	select * from contacts where contactmethod = 'Email'
) cmEmail
	on cmEmail.ContactId = c.Id
left outer join (
	select HostSummaryId, Language from languages where Language = 'English'
) lEnglish
	on lEnglish.HostSummaryId = hs.id
left outer join (
	select HostSummaryId, Language from languages where Language = 'Ukrainian'
) lUkrainian
	on lUkrainian.HostSummaryId = hs.id
left outer join (
	select HostSummaryId, Language from languages where Language = 'Polish'
) lPolish
	on lPolish.HostSummaryId = hs.id
left outer join (
	select HostSummaryId, Language from languages where Language = 'Russian'
) lRussian
	on lRussian.HostSummaryId = hs.id
left outer join (
	select HostSummaryId, Language from languages where Language = 'Slovak'
) lSlovak
	on lSlovak.HostSummaryId = hs.id
left outer join (
	select HostSummaryId, Language from languages where Language = 'Hungarian'
) lHungarian
	on lHungarian.HostSummaryId = hs.id
left outer join (
	select HostSummaryId, Language from languages where Language = 'Romanian'
) lRomanian
	on lRomanian.HostSummaryId = hs.id
left outer join (
	select HostSummaryId, Language from languages where Language = 'Other'
) lOther
	on lOther.HostSummaryId = hs.id
left outer join (
	select HostSummaryId, Restriction from restrictionstmp where restriction = 'Kids'
) rKids
	on rKids.HostSummaryId = hs.id
left outer join (
	select HostSummaryId, Restriction from restrictionstmp where restriction = 'Adult men'
) rMen
	on rMen.HostSummaryId = hs.id
left outer join (
	select HostSummaryId, Restriction from restrictionstmp where restriction = 'Adult women'
) rWomen
	on rWomen.HostSummaryId = hs.id
left outer join (
	select HostSummaryId, Restriction from restrictionstmp where restriction = 'Dogs'
) rDogs
	on rDogs.HostSummaryId = hs.id
left outer join (
	select HostSummaryId, Restriction from restrictionstmp where restriction = 'Cats'
) rCats
	on rCats.HostSummaryId = hs.id
left outer join (
	select HostSummaryId, Restriction from restrictionstmp where restriction = 'Other pets'
) rOtherPets
	on rOtherPets.HostSummaryId = hs.id