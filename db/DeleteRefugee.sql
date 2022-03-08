create or alter procedure DeleteRefugee @refugeeid uniqueidentifier
as begin
    BEGIN TRANSACTION;

    BEGIN TRY
		declare @contactid uniqueidentifier;
		set @contactid = (select top 1 Contact from Refugee where Id = @refugeeid);
		declare @summaryid uniqueidentifier;
		set @summaryid = (select top 1 Summary from Refugee where Id = @refugeeid);

		select contactmodeid into #contactmodestodelete from contacttomethods where contactid = @contactid;
		delete from contacttomethods where contactid = @contactid;
		delete from contactmode where id in (select contactmodeid from #contactmodestodelete);
		drop table #contactmodestodelete;

		delete from refugeesummarytolanguages where refugeesummaryid = @summaryid;
		delete from refugeesummarytorestrictions where refugeesummaryid = @summaryid;

		delete from refugee where id = @refugeeid;
		delete from refugeesummary where id = @summaryid;
		delete from contact where id = @contactid; 
    END TRY
    BEGIN CATCH
 
        IF @@TRANCOUNT > 0  
            ROLLBACK TRANSACTION;

		raiserror('Error deleting', 20, -1)

    END CATCH
 
    IF @@TRANCOUNT > 0  
        COMMIT TRANSACTION;
end