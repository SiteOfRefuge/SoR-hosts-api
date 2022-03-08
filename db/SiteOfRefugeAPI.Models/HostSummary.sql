CREATE TABLE [HostSummary](
	[Id] [uniqueidentifier] NOT NULL,
	[Region] [nvarchar](4000) NOT NULL,
	[AllowedPeople] [int] NOT NULL,
	[Message] [nvarchar](4000) NULL,
	[Shelter] [nvarchar](4000) NOT NULL,
	[Availability] [uniqueidentifier],
 CONSTRAINT [PK_HostSummary] PRIMARY KEY CLUSTERED 
(
	[Id]
),
 CONSTRAINT [FK_HostSummary_Availability] FOREIGN KEY([Availability])
REFERENCES [Availability] ([Id])
)

-- Property 'Restrictions' is a list (1..* relationship), so it's been added as a secondary table
-- Property 'Languages' is a list (1..* relationship), so it's been added as a secondary table