CREATE PROCEDURE ViewRefugee @id uniqueidentifier
AS
select r.id as Id,
rs.id as RefugeeSummaryId,
rs.Region as RefugeeSummaryRegion,
rs.People as RefugeeSummaryPeople,
rs.Message as RefugeeSummaryMessage,
rs.PossessionDate as RefugeePossessionDate,
c.Id as RefugeeContactId,
c.FirstName as RefugeeContactFirstName,
c.LastName as RefugeeContactLastName
from refugee r
join refugeesummary rs on r.summary = rs.id
join contact c on r.contact = c.id
where r.Id = @id;

select cm.Id,
cmm.value as contactmethod,
cm.Value,
cm.verified
from contacttomethods ctm
join contactmode cm on ctm.contactmodeid = cm.id
join contactmodemethod cmm on cm.method = cmm.id
where ctm.contactid = (select distinct contact from refugee where Id = @id);
select sl.description
from refugeesummarytolanguages rstl
join spokenlanguages sl on rstl.spokenlanguagesid = sl.id
where rstl.refugeesummaryid in (select distinct summary from refugee where Id = @id);

select r.value
from refugeesummarytorestrictions rstr
join Restrictions r on rstr.restrictionsid = r.id
where rstr.refugeesummaryid in (select distinct summary from refugee where Id = @id);
