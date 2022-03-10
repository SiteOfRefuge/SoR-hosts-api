create view Refugees as
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
		select rstl.RefugeeSummaryId, sl.value as Language,
		row_number() over (partition by rstl.RefugeeSummaryId, sl.id order by sl.id asc) as rownum
		from refugeesummarytolanguages rstl
		join spokenlanguages sl on rstl.spokenlanguagesid = sl.id
	) lInner
	where lInner.rownum = 1
), restrictionstmp as (
	select Restriction, RefugeeSummaryId from (
		select r.value as Restriction,
			rstr.RefugeeSummaryId,
			row_number() over (partition by rstr.RefugeeSummaryId, r.id order by r.id asc) as rownum
		from refugeesummarytorestrictions rstr
		join Restrictions r on rstr.restrictionsid = r.id
	) rInner
	where rInner.rownum = 1
)
select 
	r.id as Id,
	rs.id as RefugeeSummaryId,
	rs.Region as RefugeeSummaryRegion,
	rs.People as RefugeeSummaryPeople,
	rs.Message as RefugeeSummaryMessage,
	rs.PossessionDate as RefugeePossessionDate,
	c.Id as RefugeeContactId,
	c.FirstName as RefugeeContactFirstName,
	c.LastName as RefugeeContactLastName,
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
from refugee r
join refugeesummary rs on r.summary = rs.id
join contact c on r.contact = c.id
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
	select RefugeeSummaryId, Language from languages where Language = 'English'
) lEnglish
	on lEnglish.RefugeeSummaryId = rs.id
left outer join (
	select RefugeeSummaryId, Language from languages where Language = 'Ukrainian'
) lUkrainian
	on lUkrainian.RefugeeSummaryId = rs.id
left outer join (
	select RefugeeSummaryId, Language from languages where Language = 'Polish'
) lPolish
	on lPolish.RefugeeSummaryId = rs.id
left outer join (
	select RefugeeSummaryId, Language from languages where Language = 'Russian'
) lRussian
	on lRussian.RefugeeSummaryId = rs.id
left outer join (
	select RefugeeSummaryId, Language from languages where Language = 'Slovak'
) lSlovak
	on lSlovak.RefugeeSummaryId = rs.id
left outer join (
	select RefugeeSummaryId, Language from languages where Language = 'Hungarian'
) lHungarian
	on lHungarian.RefugeeSummaryId = rs.id
left outer join (
	select RefugeeSummaryId, Language from languages where Language = 'Romanian'
) lRomanian
	on lRomanian.RefugeeSummaryId = rs.id
left outer join (
	select RefugeeSummaryId, Language from languages where Language = 'Other'
) lOther
	on lOther.RefugeeSummaryId = rs.id
left outer join (
	select RefugeeSummaryId, Restriction from restrictionstmp where restriction = 'Kids'
) rKids
	on rKids.RefugeeSummaryId = rs.id
left outer join (
	select RefugeeSummaryId, Restriction from restrictionstmp where restriction = 'Adult men'
) rMen
	on rMen.RefugeeSummaryId = rs.id
left outer join (
	select RefugeeSummaryId, Restriction from restrictionstmp where restriction = 'Adult women'
) rWomen
	on rWomen.RefugeeSummaryId = rs.id
left outer join (
	select RefugeeSummaryId, Restriction from restrictionstmp where restriction = 'Dogs'
) rDogs
	on rDogs.RefugeeSummaryId = rs.id
left outer join (
	select RefugeeSummaryId, Restriction from restrictionstmp where restriction = 'Cats'
) rCats
	on rCats.RefugeeSummaryId = rs.id
left outer join (
	select RefugeeSummaryId, Restriction from restrictionstmp where restriction = 'Other pets'
) rOtherPets
	on rOtherPets.RefugeeSummaryId = rs.id