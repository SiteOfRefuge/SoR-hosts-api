CREATE PROCEDURE ViewHost @id uniqueidentifier
AS
select 
    h.id as Id,
    hs.id as HostSummaryId,
    hs.Region as HostSummaryRegion,
    hs.AllowedPeople as HostSummaryPeople,
    hs.Message as HostSummaryMessage,
    hs.Shelter as HostSummaryShelter,
    hs.Availability as HostSummaryAvailabilityId,
    a.DateAvailable as AvailabilityDateAvailable,
    a.Active as AvailabilityActive,
    alos.value as AvailabilityLengthOfStayValue,
    c.Id as RefugeeContactId,
    c.FirstName as RefugeeContactFirstName,
    c.LastName as RefugeeContactLastName
from host h
    join hostsummary hs 
        on h.summary = hs.id
    join availability a
        on hs.availability = a.id
    left outer join AvailabilityLengthOfStay alos
        on a.LengthOfStay = alos.Id
    join contact c 
        on h.contact = c.id
where h.Id = @id;

select cm.Id,
cmm.value as contactmethod,
cm.Value,
cm.verified
from contacttomethods ctm
join contactmode cm on ctm.contactmodeid = cm.id
join contactmodemethod cmm on cm.method = cmm.id
where ctm.contactid in (select contact from host where Id = @id);

select sl.value
from hostsummarytolanguages hstl
join spokenlanguages sl on hstl.spokenlanguagesid = sl.id
where hstl.hostsummaryid in (select contact from host where Id = @id);

select r.value
from hostsummarytorestrictions hstr
join Restrictions r on hstr.restrictionsid = r.id
where hstr.hostsummaryid = (select contact from host where Id = @id);
