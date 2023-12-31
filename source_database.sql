USE [nodejs]
GO
/****** Object:  Table [dbo].[app_list]    Script Date: 28/07/2023 10:52:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[app_list](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[node_type] [varchar](50) NULL,
	[app_type] [varchar](50) NULL,
	[app_desc] [varchar](250) NULL,
	[token] [varchar](max) NULL,
	[create_date] [datetime] NULL,
	[update_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[settings]    Script Date: 28/07/2023 10:52:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[settings](
	[id] [varchar](100) NOT NULL,
	[desc] [varchar](400) NULL,
	[value] [varchar](100) NULL,
	[create_date] [datetime] NULL DEFAULT (getdate()),
	[update_date] [datetime] NULL DEFAULT (getdate())
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[whatsapp_js]    Script Date: 28/07/2023 10:52:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[whatsapp_js](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[phone_number] [varchar](50) NULL,
	[message] [nvarchar](max) NOT NULL,
	[attachment] [nvarchar](max) NULL,
	[attachment_type] [varchar](50) NULL,
	[attachment_location] [varchar](100) NULL,
	[attachment_filename] [varchar](150) NULL,
	[schedule_date] [datetime] NULL CONSTRAINT [DF_whatsapp_js_schedule_date]  DEFAULT (getdate()),
	[source_program] [varchar](50) NULL,
	[sender_refid] [varchar](50) NULL,
	[sender_notes] [varchar](250) NULL,
	[receiver_refid] [varchar](50) NULL,
	[receiver_notes] [varchar](250) NULL,
	[create_date] [datetime] NULL CONSTRAINT [DF__whatsapp___creat__108B795B]  DEFAULT (getdate()),
	[update_date] [datetime] NULL,
	[status] [tinyint] NULL,
	[onprocess] [tinyint] NULL DEFAULT ((0)),
	[priority] [int] NULL DEFAULT ((100))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Node JS General Settings' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'settings'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'local => Di Server tempat Node JS
url => URL file nya' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'whatsapp_js', @level2type=N'COLUMN',@level2name=N'attachment_location'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Table for Managing Whatsapp Web JS Scheduled Node' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'whatsapp_js'
GO
