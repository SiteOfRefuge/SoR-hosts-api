CREATE TABLE [RefugeeSummary](
	[Id] [uniqueidentifier] NOT NULL,
	[Region] [nvarchar](4000) NOT NULL,
	[People] [int] NOT NULL,
	[Message] [nvarchar](4000) NULL,
	[PossessionDate] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_RefugeeSummary] PRIMARY KEY CLUSTERED 
(
	[Id]
)
)

-- Property 'Restrictions' is a list (1..* relationship), so it's been added as a secondary table
-- Property 'Languages' is a list (1..* relationship), so it's been added as a secondary table