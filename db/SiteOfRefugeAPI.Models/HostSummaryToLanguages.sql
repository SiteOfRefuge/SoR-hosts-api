CREATE TABLE [HostSummaryToLanguages](
	[HostSummaryId] [uniqueidentifier] NOT NULL,
	[SpokenLanguagesId] [int] NOT NULL,
 CONSTRAINT [FK_HostSummaryToLanguages_HostSummary] FOREIGN KEY([HostSummaryId])
REFERENCES [HostSummary] ([Id]),
 CONSTRAINT [FK_HostSummaryToLanguages_SpokenLanguages] FOREIGN KEY([SpokenLanguagesId])
REFERENCES [SpokenLanguages] ([Id])
)
