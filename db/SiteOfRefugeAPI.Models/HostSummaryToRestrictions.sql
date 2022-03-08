CREATE TABLE [HostSummaryToRestrictions](
	[HostSummaryId] [uniqueidentifier] NOT NULL,
	[RestrictionsId] [int] NOT NULL,
 CONSTRAINT [FK_HostSummaryToRestrictions_HostSummary] FOREIGN KEY([HostSummaryId])
REFERENCES [HostSummary] ([Id]),
 CONSTRAINT [FK_HostSummaryToRestrictions_Restrictions] FOREIGN KEY([RestrictionsId])
REFERENCES [Restrictions] ([Id])
)
