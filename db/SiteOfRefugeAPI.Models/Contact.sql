CREATE TABLE [Contact](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](4000) NOT NULL,
 CONSTRAINT [PK_Contact] PRIMARY KEY CLUSTERED 
(
	[Id]
)
)

-- Property 'Methods' is a list (1..* relationship), so it's been added as a secondary table