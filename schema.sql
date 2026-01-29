-- [PTTEPi-MDR].dbo.SyncTagLog definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.SyncTagLog;

CREATE TABLE SyncTagLog (
	syncDate datetime NOT NULL,
	total_inserted int NOT NULL,
	total_updated int NOT NULL
);


-- [PTTEPi-MDR].dbo.[__MigrationHistory] definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.[__MigrationHistory];

CREATE TABLE [__MigrationHistory] (
	MigrationId nvarchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	ContextKey nvarchar(300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Model varbinary(MAX) NOT NULL,
	ProductVersion nvarchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT [PK_dbo.__MigrationHistory] PRIMARY KEY (MigrationId,ContextKey)
);


-- [PTTEPi-MDR].dbo.activity_report definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.activity_report;

CREATE TABLE activity_report (
	reportID int IDENTITY(1,1) NOT NULL,
	disciplineID int NOT NULL,
	reportDate date DEFAULT NULL NULL,
	reportWON varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	reportSubject text COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	reportDescription text COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	reportRemark text COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	reportPerformer nvarchar(225) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	activitytypeID int NOT NULL,
	workstatusID int NOT NULL,
	tagID int NULL,
	reportRecordUser text COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	reportUpdatedUser nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	reportUpdatedTime datetime NULL,
	reportRecordTime datetime NULL,
	attached_files nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	reportAttach1 nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT '' NULL,
	reportAttach2 nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT '' NULL,
	siteID int NULL,
	IsDeleted int NULL,
	reportDescriptionWithoutImage nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK_activity_report PRIMARY KEY (reportID)
);
 CREATE NONCLUSTERED INDEX IDX_activity_report_reportDate_IsDeleted ON dbo.activity_report (  reportDate ASC  , IsDeleted ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX idx_activity_report_reportDate_isDeleted_tagID ON dbo.activity_report (  reportDate ASC  , IsDeleted ASC  , tagID ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- [PTTEPi-MDR].dbo.activity_report_tagdata definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.activity_report_tagdata;

CREATE TABLE activity_report_tagdata (
	id int IDENTITY(1,1) NOT NULL,
	tagID int NULL,
	reportID int NULL,
	CONSTRAINT PK_activity_report_tag PRIMARY KEY (id)
);
 CREATE NONCLUSTERED INDEX IDX_activity_report_tagdata_reportId ON dbo.activity_report_tagdata (  reportID ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX idx_activity_report_tagdata_reportID_tagID ON dbo.activity_report_tagdata (  reportID ASC  , tagID ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- [PTTEPi-MDR].dbo.activity_type definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.activity_type;

CREATE TABLE activity_type (
	activitytypeID int IDENTITY(1,1) NOT NULL,
	activitytypeName varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	activitytypeDescription text COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	siteID int NULL,
	status int NULL,
	CONSTRAINT PK_activity_type PRIMARY KEY (activitytypeID)
);


-- [PTTEPi-MDR].dbo.archive_report definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.archive_report;

CREATE TABLE archive_report (
	archiveID int NOT NULL,
	archiveDate datetime DEFAULT NULL NULL,
	archiveTagno varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	archiveFunction varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	archiveLocation varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	archiveWON varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	archiveRunninghours varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	archiveActivity varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	archiveDescriptions text COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	archivePMType varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	archiveTDAN_NO varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	archiveDAN_NO varchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	archiveICUF_NO varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	archiveVocab_NO varchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	archiveRemarks text COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	archivePerformers varchar(225) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	archiveStatus varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	siteID int NULL,
	CONSTRAINT PK_archive_report PRIMARY KEY (archiveID)
);


-- [PTTEPi-MDR].dbo.dashboard definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.dashboard;

CREATE TABLE dashboard (
	id int IDENTITY(1,1) NOT NULL,
	title nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	description nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	embedUrl nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	thumbnail nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	isActive bit DEFAULT 1 NULL,
	seq int NULL,
	created datetime NULL,
	createdBy nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	updated datetime NULL,
	updatedBy nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK_dashboard PRIMARY KEY (id)
);


-- [PTTEPi-MDR].dbo.discipline definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.discipline;

CREATE TABLE discipline (
	disciplineID int IDENTITY(1,1) NOT NULL,
	disciplineName varchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	siteID int NULL,
	status int NULL,
	CONSTRAINT PK_discipline PRIMARY KEY (disciplineID)
);


-- [PTTEPi-MDR].dbo.email_log definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.email_log;

CREATE TABLE email_log (
	ID int IDENTITY(1,1) NOT NULL,
	ReportID int NULL,
	Email nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	SentBy nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	SentDate datetime NOT NULL,
	CONSTRAINT [PK_dbo.email_log] PRIMARY KEY (ID)
);


-- [PTTEPi-MDR].dbo.location definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.location;

CREATE TABLE location (
	locationID int IDENTITY(1,1) NOT NULL,
	locationName varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	locationDescription text COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	siteID int NULL,
	status int NULL,
	CONSTRAINT PK_location PRIMARY KEY (locationID)
);


-- [PTTEPi-MDR].dbo.master_site definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.master_site;

CREATE TABLE master_site (
	id int IDENTITY(1,1) NOT NULL,
	site_name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	site_abbr nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK_master_site PRIMARY KEY (id)
);


-- [PTTEPi-MDR].dbo.spare_category definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.spare_category;

CREATE TABLE spare_category (
	ID int IDENTITY(1,1) NOT NULL,
	name nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	siteID int NULL,
	status int NULL,
	CONSTRAINT PK_spare_category PRIMARY KEY (ID)
);


-- [PTTEPi-MDR].dbo.spare_data definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.spare_data;

CREATE TABLE spare_data (
	ID int IDENTITY(1,1) NOT NULL,
	Group_ID int NOT NULL,
	Subgroup_ID int DEFAULT NULL NULL,
	Discipline_ID int NOT NULL,
	Package varchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT '' NULL,
	Category varchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT '' NULL,
	MESC varchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	Manufacturer varchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	Model varchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	Partno varchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	Serialno varchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	Tag_ID text COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	Description text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Remark text COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT NULL NULL,
	Qty int DEFAULT 0 NOT NULL,
	Minqty int DEFAULT 0 NOT NULL,
	SiteID int NULL,
	attached_files nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	image_urls nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	srcMesc nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	syncDate datetime NULL,
	srcChangedOn datetime NULL,
	Status int NULL,
	CONSTRAINT PK_spare_data PRIMARY KEY (ID)
);


-- [PTTEPi-MDR].dbo.spare_discipline definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.spare_discipline;

CREATE TABLE spare_discipline (
	ID int IDENTITY(1,1) NOT NULL,
	Discipline_Name varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	siteID int NULL,
	status int NULL,
	CONSTRAINT PK_spare_discipline PRIMARY KEY (ID)
);


-- [PTTEPi-MDR].dbo.spare_group definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.spare_group;

CREATE TABLE spare_group (
	ID int IDENTITY(1,1) NOT NULL,
	Group_Name varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	status int DEFAULT 0 NULL,
	siteID int NULL,
	CONSTRAINT PK_spare_group PRIMARY KEY (ID)
);


-- [PTTEPi-MDR].dbo.spare_package definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.spare_package;

CREATE TABLE spare_package (
	ID int IDENTITY(1,1) NOT NULL,
	Unit int NOT NULL,
	Package_Name varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	siteID int NULL,
	status int NULL,
	CONSTRAINT PK_spare_package PRIMARY KEY (ID)
);


-- [PTTEPi-MDR].dbo.spare_status definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.spare_status;

CREATE TABLE spare_status (
	ID int IDENTITY(1,1) NOT NULL,
	Status_Name char(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	siteID int NULL,
	CONSTRAINT PK_spare_status PRIMARY KEY (ID)
);


-- [PTTEPi-MDR].dbo.spare_subgroup definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.spare_subgroup;

CREATE TABLE spare_subgroup (
	ID int IDENTITY(1,1) NOT NULL,
	Group_ID int NULL,
	Subgroup_Name varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	siteID int NULL,
	status int NULL,
	CONSTRAINT PK_spare_subgroup PRIMARY KEY (ID)
);


-- [PTTEPi-MDR].dbo.spare_transaction definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.spare_transaction;

CREATE TABLE spare_transaction (
	ID int IDENTITY(1,1) NOT NULL,
	Sparepart_ID int NOT NULL,
	[Date] date NOT NULL,
	DAN varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT '' NOT NULL,
	WO varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT '' NOT NULL,
	PO varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT '' NOT NULL,
	Updateby varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Detail text COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Type_ID int NOT NULL,
	Qty tinyint NOT NULL,
	Location varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT '' NOT NULL,
	Container varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT '' NOT NULL,
	Shelf varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT '' NOT NULL,
	siteID int NULL,
	status int NULL,
	reportID int NULL,
	CreatedBy nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ModifiedBy nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Created datetime NULL,
	Modified datetime NULL,
	CONSTRAINT PK_spare_transaction PRIMARY KEY (ID)
);


-- [PTTEPi-MDR].dbo.spare_transaction_type definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.spare_transaction_type;

CREATE TABLE spare_transaction_type (
	ID int IDENTITY(1,1) NOT NULL,
	Name varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	siteID int NULL,
	status int NULL,
	CONSTRAINT PK__spare_tr__3214EC279B7FDC28 PRIMARY KEY (ID)
);


-- [PTTEPi-MDR].dbo.sparedata_BK_20210430 definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.sparedata_BK_20210430;

CREATE TABLE sparedata_BK_20210430 (
	ID int IDENTITY(1,1) NOT NULL,
	Group_ID int NOT NULL,
	Subgroup_ID int NULL,
	Discipline_ID int NOT NULL,
	Package varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Category varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	MESC varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Manufacturer varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Model varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Partno varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Serialno varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Tag_ID text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Description text COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Remark text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Qty int NOT NULL,
	Minqty int NOT NULL,
	SiteID int NULL,
	attached_files nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	image_urls nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	srcMesc nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	syncDate datetime NULL,
	srcChangedOn datetime NULL,
	Status int NULL
);


-- [PTTEPi-MDR].dbo.sysdiagrams definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.sysdiagrams;

CREATE TABLE sysdiagrams (
	name sysname COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	principal_id int NOT NULL,
	diagram_id int IDENTITY(1,1) NOT NULL,
	version int NULL,
	definition varbinary(MAX) NULL,
	CONSTRAINT PK__sysdiagr__C2B05B61869E0A98 PRIMARY KEY (diagram_id),
	CONSTRAINT UK_principal_name UNIQUE (principal_id,name)
);


-- [PTTEPi-MDR].dbo.tagdata definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.tagdata;

CREATE TABLE tagdata (
	tagID int IDENTITY(1,1) NOT NULL,
	tagNo nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	tagName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	locationID int NOT NULL,
	siteID int NULL,
	status int NULL,
	parentID int NULL,
	[level] int NULL,
	sort int NULL,
	srcTag nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	syncDate datetime NULL,
	srcChangedOn datetime NULL,
	CONSTRAINT PK_tagdata PRIMARY KEY (tagID)
);
 CREATE NONCLUSTERED INDEX IDX_tagdata_tagId_locationId ON dbo.tagdata (  tagID ASC  , locationID ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX IX_Tagdata_tagName ON dbo.tagdata (  tagNo ASC  , tagName ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX idx_tagdata_locationID ON dbo.tagdata (  locationID ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX idx_tagdata_status_tagID ON dbo.tagdata (  status ASC  , tagID ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- [PTTEPi-MDR].dbo.tagdata_BK_20210430 definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.tagdata_BK_20210430;

CREATE TABLE tagdata_BK_20210430 (
	tagID int IDENTITY(1,1) NOT NULL,
	tagNo text COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	tagName text COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	locationID int NOT NULL,
	siteID int NULL,
	status int NULL,
	parentID int NULL,
	[level] int NULL,
	sort int NULL,
	srcTag nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	syncDate datetime NULL,
	srcChangedOn datetime NULL
);


-- [PTTEPi-MDR].dbo.tagdata_backup definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.tagdata_backup;

CREATE TABLE tagdata_backup (
	tagID int NOT NULL,
	tagNo text COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	tagName text COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	locationID int NOT NULL,
	siteID int NULL,
	status int NULL,
	location varchar(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
);


-- [PTTEPi-MDR].dbo.tagdata_bk_20210604 definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.tagdata_bk_20210604;

CREATE TABLE tagdata_bk_20210604 (
	tagID int IDENTITY(1,1) NOT NULL,
	tagNo text COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	tagName text COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	locationID int NOT NULL,
	siteID int NULL,
	status int NULL,
	parentID int NULL,
	[level] int NULL,
	sort int NULL,
	srcTag nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	syncDate datetime NULL,
	srcChangedOn datetime NULL
);


-- [PTTEPi-MDR].dbo.temp definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.temp;

CREATE TABLE temp (
	ID int NULL,
	a1 varchar(3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	a2 varchar(3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	a3 varchar(3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	a4 text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	a5 varchar(3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	a6 varchar(3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	a7 varchar(3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	a8 varchar(3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	a9 varchar(3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	a10 varchar(3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	a11 varchar(3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	a12 varchar(3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	a13 varchar(3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	a14 varchar(3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	a15 varchar(3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
);


-- [PTTEPi-MDR].dbo.user_config definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.user_config;

CREATE TABLE user_config (
	id int IDENTITY(2,1) NOT NULL,
	accountname nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	site_id int NOT NULL,
	roles nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK_user_config PRIMARY KEY (id)
);


-- [PTTEPi-MDR].dbo.workstatus definition

-- Drop table

-- DROP TABLE [PTTEPi-MDR].dbo.workstatus;

CREATE TABLE workstatus (
	workstatusID int IDENTITY(1,1) NOT NULL,
	workstatusName text COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	siteID int NULL,
	status int NULL,
	CONSTRAINT PK_workstatus PRIMARY KEY (workstatusID)
);