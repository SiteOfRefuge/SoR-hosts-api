CREATE TABLE [RefugeeSummaryToLanguages](
	[RefugeeSummaryId] [uniqueidentifier] NOT NULL,
	[SpokenLanguagesId] [int] NOT NULL,
 CONSTRAINT [FK_RefugeeSummaryToLanguages_RefugeeSummary] FOREIGN KEY([RefugeeSummaryId])
REFERENCES [RefugeeSummary] ([Id]),
 CONSTRAINT [FK_RefugeeSummaryToLanguages_SpokenLanguages] FOREIGN KEY([SpokenLanguagesId])
REFERENCES [SpokenLanguages] ([Id])
)
