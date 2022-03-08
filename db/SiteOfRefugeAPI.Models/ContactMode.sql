CREATE TABLE [ContactMode](
	[Id] [uniqueidentifier] NOT NULL,
	[Method] [int],
	[Value] [nvarchar](4000) NOT NULL,
	[Verified] [bit] NULL,
 CONSTRAINT [PK_ContactMode] PRIMARY KEY CLUSTERED 
(
	[Id]
),
 CONSTRAINT [FK_ContactMode_ContactModeMethod] FOREIGN KEY([Method])
REFERENCES [ContactModeMethod] ([Id])
)
