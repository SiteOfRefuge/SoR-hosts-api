CREATE TABLE [RefugeeSummaryToRestrictions](
	[RefugeeSummaryId] [uniqueidentifier] NOT NULL,
	[RestrictionsId] [int] NOT NULL,
 CONSTRAINT [FK_RefugeeSummaryToRestrictions_RefugeeSummary] FOREIGN KEY([RefugeeSummaryId])
REFERENCES [RefugeeSummary] ([Id]),
 CONSTRAINT [FK_RefugeeSummaryToRestrictions_Restrictions] FOREIGN KEY([RestrictionsId])
REFERENCES [Restrictions] ([Id])
)
