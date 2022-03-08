CREATE TABLE [Host](
	[Id] [uniqueidentifier] NOT NULL,
	[Summary] [uniqueidentifier],
	[Contact] [uniqueidentifier],
	IsEnabled bit constraint host_enabled_default default 1
 CONSTRAINT [PK_Host] PRIMARY KEY CLUSTERED 
(
	[Id]
),
 CONSTRAINT [FK_Host_Contact] FOREIGN KEY([Contact])
REFERENCES [Contact] ([Id]),
 CONSTRAINT [FK_Host_HostSummary] FOREIGN KEY([Summary])
REFERENCES [HostSummary] ([Id])
)
