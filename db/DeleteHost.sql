create or alter procedure DeleteHost @hostid uniqueidentifier
as begin
    BEGIN TRANSACTION;

    BEGIN TRY
        declare @contactid uniqueidentifier;
        set @contactid = (select top 1 Contact from Host where Id = @hostid);
        declare @summaryid uniqueidentifier;
        set @summaryid = (select top 1 Summary from Host where Id = @hostid);
        declare @availabilityid uniqueidentifier;
        set @availabilityid = (select top 1 availability from HostSummary where Id = @summaryid);


        select contactmodeid into #contactmodestodelete from contacttomethods where contactid = @contactid;
        delete from contacttomethods where contactid = @contactid;
        delete from contactmode where id in (select contactmodeid from #contactmodestodelete);
        drop table #contactmodestodelete;

        delete from hostsummarytolanguages where hostsummaryid = @summaryid;
        delete from hostsummarytorestrictions where hostsummaryid = @summaryid;

        delete from host where id = @hostid;
        delete from hostsummary where id = @summaryid;
        delete from availability where id = @availabilityid;
        delete from contact where id = @contactid;    END TRY
    BEGIN CATCH
 
        IF @@TRANCOUNT > 0  
            ROLLBACK TRANSACTION;

		raiserror('Error deleting', 20, -1) 

    END CATCH
 
    IF @@TRANCOUNT > 0  
        COMMIT TRANSACTION;
end