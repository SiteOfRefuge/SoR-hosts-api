CREATE TABLE [Refugee](
	[Id] [uniqueidentifier] NOT NULL,
	[Summary] [uniqueidentifier],
	[Contact] [uniqueidentifier],
	IsEnabled bit constraint refugee_enabled_default default 1	
 CONSTRAINT [PK_Refugee] PRIMARY KEY CLUSTERED 
(
	[Id]
),
 CONSTRAINT [FK_Refugee_Contact] FOREIGN KEY([Contact])
REFERENCES [Contact] ([Id]),
 CONSTRAINT [FK_Refugee_RefugeeSummary] FOREIGN KEY([Summary])
REFERENCES [RefugeeSummary] ([Id])
)
