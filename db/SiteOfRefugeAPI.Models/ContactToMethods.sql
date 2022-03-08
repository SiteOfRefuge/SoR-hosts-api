CREATE TABLE [ContactToMethods](
	[ContactId] [uniqueidentifier] NOT NULL,
	[ContactModeId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [FK_ContactToMethods_Contact] FOREIGN KEY([ContactId])
REFERENCES [Contact] ([Id]),
 CONSTRAINT [FK_ContactToMethods_ContactMode] FOREIGN KEY([ContactModeId])
REFERENCES [ContactMode] ([Id])
)
