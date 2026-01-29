-- public.activity_types definition

-- Drop table

-- DROP TABLE activity_types;

CREATE TABLE activity_types (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE),
	activitytype_name text NOT NULL,
	activitytype_description text NULL,
	site_id int4 NULL,
	status int4 NULL,
	created_at varchar(255) NULL,
	updated_at varchar(255) NULL,
	created_date timestamp NULL,
	updated_date timestamp NULL,
	asset varchar(255) NULL,
	CONSTRAINT activity_types_pkey PRIMARY KEY (id)
);


-- public.asset_user definition

-- Drop table

-- DROP TABLE asset_user;

CREATE TABLE asset_user (
	id serial4 NOT NULL,
	"name" varchar(255) NULL,
	email varchar(255) NULL,
	asset varchar(255) NULL,
	created_date timestamp NULL,
	updated_date timestamp NULL,
	CONSTRAINT asset_user_pkey PRIMARY KEY (id),
	CONSTRAINT unique_email UNIQUE (email)
);


-- public.atlas_schema_revisions definition

-- Drop table

-- DROP TABLE atlas_schema_revisions;

CREATE TABLE atlas_schema_revisions (
	"version" varchar NOT NULL,
	description varchar NOT NULL,
	"type" int8 NOT NULL DEFAULT 2,
	applied int8 NOT NULL DEFAULT 0,
	total int8 NOT NULL DEFAULT 0,
	executed_at timestamptz NOT NULL,
	execution_time int8 NOT NULL,
	"error" text NULL,
	error_stmt text NULL,
	hash varchar NOT NULL,
	partial_hashes jsonb NULL,
	operator_version varchar NOT NULL,
	CONSTRAINT atlas_schema_revisions_pkey PRIMARY KEY (version)
);


-- public.cart_items definition

-- Drop table

-- DROP TABLE cart_items;

CREATE TABLE cart_items (
	id bigserial NOT NULL,
	email text NOT NULL,
	material_no text NOT NULL,
	plant text NULL,
	quantity int8 NOT NULL,
	"location" text NULL,
	shelf text NULL,
	container text NULL,
	created_at timestamptz NULL,
	updated_at timestamptz NULL,
	mat_description_maktx text NULL,
	CONSTRAINT cart_items_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_cart_items_email ON public.cart_items USING btree (email);


-- public.daily_reports definition

-- Drop table

-- DROP TABLE daily_reports;

CREATE TABLE daily_reports (
	id int4 NOT NULL DEFAULT nextval('daily_reports_report_id_seq'::regclass),
	work_order_no varchar(255) NULL,
	activities_subject text NULL,
	discipline varchar(255) NULL,
	activities_type varchar(255) NULL,
	work_status varchar(255) NULL,
	report_created timestamp NULL,
	time_start varchar(50) NULL,
	time_end varchar(50) NULL,
	failure_found text NULL,
	task_description text NULL,
	task_remark text NULL,
	created_date timestamp NULL,
	updated_date timestamp NULL,
	created_at varchar(50) NULL,
	updated_at varchar(50) NULL,
	is_deleted bool NULL DEFAULT false,
	function_location varchar(255) NULL,
	parent int8 NULL,
	asset varchar(255) NULL,
	is_sum bool NOT NULL DEFAULT false,
	working_hours numeric(10, 2) NULL DEFAULT 0.00,
	group_ids text NULL,
	CONSTRAINT daily_reports_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_daily_activities_type ON public.daily_reports USING btree (activities_type);
CREATE INDEX idx_daily_asset ON public.daily_reports USING btree (asset);
CREATE INDEX idx_daily_created_asset_deleted ON public.daily_reports USING btree (created_date DESC, asset, is_deleted);
CREATE INDEX idx_daily_created_date ON public.daily_reports USING btree (created_date);
CREATE INDEX idx_daily_discipline ON public.daily_reports USING btree (discipline);
CREATE INDEX idx_daily_is_deleted ON public.daily_reports USING btree (is_deleted);
CREATE INDEX idx_daily_reports_group_ids ON public.daily_reports USING btree (group_ids);
CREATE INDEX idx_daily_reports_is_sum ON public.daily_reports USING btree (is_sum);
CREATE INDEX idx_daily_reports_working_hours ON public.daily_reports USING btree (working_hours);
CREATE INDEX idx_daily_search ON public.daily_reports USING btree (created_date, asset, discipline, activities_type);


-- public.disciplines definition

-- Drop table

-- DROP TABLE disciplines;

CREATE TABLE disciplines (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE),
	discipline_name text NOT NULL,
	site_id int4 NULL,
	status int4 NULL,
	created_at varchar(255) NULL,
	updated_at varchar(255) NULL,
	created_date timestamp NULL,
	updated_date timestamp NULL,
	asset varchar(255) NULL,
	CONSTRAINT disciplines_pkey PRIMARY KEY (id)
);


-- public.file_daily_report definition

-- Drop table

-- DROP TABLE file_daily_report;

CREATE TABLE file_daily_report (
	id serial4 NOT NULL,
	report_id int4 NOT NULL,
	file text NULL,
	created_date timestamp NULL,
	updated_date timestamp NULL,
	created_at varchar(50) NULL,
	updated_at varchar(50) NULL,
	"type" varchar(255) NULL,
	description varchar(255) NULL,
	"path" varchar(255) NULL,
	CONSTRAINT file_daily_report_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_file_daily_report_report_id ON public.file_daily_report USING btree (report_id);


-- public.focal_points_master definition

-- Drop table

-- DROP TABLE focal_points_master;

CREATE TABLE focal_points_master (
	id bigserial NOT NULL,
	"name" text NOT NULL,
	created_at timestamptz NULL,
	updated_at timestamptz NULL,
	asset text NULL,
	CONSTRAINT focal_points_master_pkey PRIMARY KEY (id),
	CONSTRAINT uni_focal_points_master_name UNIQUE (name)
);
CREATE INDEX idx_focal_points_master_name ON public.focal_points_master USING btree (name);


-- public.hash_tags definition

-- Drop table

-- DROP TABLE hash_tags;

CREATE TABLE hash_tags (
	id serial4 NOT NULL,
	report_id int4 NOT NULL,
	"name" text NOT NULL,
	created_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	updated_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	created_at text NULL,
	updated_at text NULL,
	CONSTRAINT hash_tags_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_hash_tags_report_id ON public.hash_tags USING btree (report_id);


-- public.hash_tags_master definition

-- Drop table

-- DROP TABLE hash_tags_master;

CREATE TABLE hash_tags_master (
	id serial4 NOT NULL,
	"name" text NULL,
	created_date timestamp NOT NULL,
	updated_date timestamp NOT NULL,
	created_at text NULL,
	updated_at text NULL,
	asset text NULL,
	CONSTRAINT hash_tags_master_pkey PRIMARY KEY (id)
);


-- public.highlight_summary definition

-- Drop table

-- DROP TABLE highlight_summary;

CREATE TABLE highlight_summary (
	id serial4 NOT NULL,
	activity_date date NOT NULL,
	job_detail text NULL,
	job_status varchar(50) NULL,
	job_title varchar(255) NULL,
	platform varchar(100) NULL,
	unit varchar(100) NULL,
	created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
	created_by varchar(100) NULL,
	updated_by varchar(100) NULL,
	is_deleted bool NULL DEFAULT false,
	CONSTRAINT highlight_summary_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_highlight_summary_activity_date ON public.highlight_summary USING btree (activity_date);
CREATE INDEX idx_highlight_summary_created_at ON public.highlight_summary USING btree (created_at);
CREATE INDEX idx_highlight_summary_is_deleted ON public.highlight_summary USING btree (is_deleted);
CREATE INDEX idx_highlight_summary_job_status ON public.highlight_summary USING btree (job_status);
CREATE INDEX idx_highlight_summary_platform ON public.highlight_summary USING btree (platform);
CREATE INDEX idx_highlight_summary_unit ON public.highlight_summary USING btree (unit);


-- public.inventories definition

-- Drop table

-- DROP TABLE inventories;

CREATE TABLE inventories (
	id bigserial NOT NULL,
	material_no text NOT NULL,
	part_no text NOT NULL,
	manufacture text NOT NULL,
	model text NOT NULL,
	detail text NOT NULL,
	min_qty int8 NOT NULL,
	remark text NOT NULL,
	asset text NOT NULL,
	is_deleted bool NULL DEFAULT false,
	created_date timestamptz NULL,
	updated_date timestamptz NULL,
	created_at timestamptz NULL,
	updated_at timestamptz NULL,
	CONSTRAINT inventories_pkey PRIMARY KEY (id),
	CONSTRAINT uni_inventories_material_no UNIQUE (material_no)
);
CREATE INDEX idx_inventories_material_no ON public.inventories USING btree (material_no);


-- public.inventory_extensions definition

-- Drop table

-- DROP TABLE inventory_extensions;

CREATE TABLE inventory_extensions (
	id bigserial NOT NULL,
	material_no text NOT NULL,
	detail text NOT NULL,
	plant text NULL,
	min_qty int8 NOT NULL,
	remark text NOT NULL,
	is_active bool NULL DEFAULT true,
	created_date timestamptz NULL,
	updated_date timestamptz NULL,
	created_at timestamptz NULL,
	updated_at timestamptz NULL,
	CONSTRAINT inventory_extensions_pkey PRIMARY KEY (id)
);


-- public.notification_logs definition

-- Drop table

-- DROP TABLE notification_logs;

CREATE TABLE notification_logs (
	id serial4 NOT NULL,
	report_id int4 NOT NULL,
	email varchar(255) NULL,
	"type" varchar(100) NULL,
	created_date timestamp NULL,
	updated_date timestamp NULL,
	created_at varchar(50) NULL,
	updated_at varchar(50) NULL,
	CONSTRAINT notification_logs_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_notification_logs_report_id ON public.notification_logs USING btree (report_id);


-- public.raw_summary_data definition

-- Drop table

-- DROP TABLE raw_summary_data;

CREATE TABLE raw_summary_data (
	id serial4 NOT NULL,
	report_id int4 NOT NULL,
	workorder varchar(255) NULL,
	working_hours numeric(10, 2) NULL DEFAULT 0.00,
	unique_key varchar(500) NOT NULL,
	created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT raw_summary_data_pkey PRIMARY KEY (id),
	CONSTRAINT raw_summary_data_unique_key_key UNIQUE (unique_key)
);
CREATE INDEX idx_raw_summary_data_created_at ON public.raw_summary_data USING btree (created_at);
CREATE INDEX idx_raw_summary_data_report_id ON public.raw_summary_data USING btree (report_id);
CREATE INDEX idx_raw_summary_data_unique_key ON public.raw_summary_data USING btree (unique_key);
CREATE INDEX idx_raw_summary_data_workorder ON public.raw_summary_data USING btree (workorder);


-- public.spare definition

-- Drop table

-- DROP TABLE spare;

CREATE TABLE spare (
	id serial4 NOT NULL,
	report_id int4 NOT NULL,
	"action" varchar(255) NULL,
	mesc varchar(255) NULL,
	detail text NULL,
	qty varchar(50) NULL,
	created_date timestamp NULL,
	updated_date timestamp NULL,
	created_at varchar(50) NULL,
	updated_at varchar(50) NULL,
	plant varchar(255) NULL,
	CONSTRAINT spare_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_spare_report_id ON public.spare USING btree (report_id);


-- public.tags definition

-- Drop table

-- DROP TABLE tags;

CREATE TABLE tags (
	id bigserial NOT NULL,
	report_id int8 NULL,
	equipment_no varchar(100) NULL,
	technical_id_no varchar(100) NULL,
	technical_object_description text NULL,
	superior_functional_location varchar(100) NULL,
	superior_equipment varchar(100) NULL,
	"text" text NULL,
	"location" varchar(100) NULL,
	children bool NULL,
	created_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	updated_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT tags_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_tags_report_id ON public.tags USING btree (report_id);


-- public.tags_master definition

-- Drop table

-- DROP TABLE tags_master;

CREATE TABLE tags_master (
	id serial4 NOT NULL,
	tag_no text NULL,
	tag_name text NULL,
	"location" text NULL,
	site text NULL,
	status text NULL,
	parent int4 NULL,
	parent_name varchar(255) NULL,
	created_date timestamp NULL,
	updated_date timestamp NULL,
	created_at text NULL,
	updated_at text NULL,
	asset varchar(255) NULL,
	CONSTRAINT tags_master_pkey PRIMARY KEY (id)
);


-- public.task_owner definition

-- Drop table

-- DROP TABLE task_owner;

CREATE TABLE task_owner (
	id serial4 NOT NULL,
	report_id int4 NOT NULL,
	"name" varchar(255) NULL,
	email varchar(255) NULL,
	created_date timestamp NULL,
	updated_date timestamp NULL,
	created_at varchar(50) NULL,
	updated_at varchar(50) NULL,
	"type" varchar(255) NULL,
	CONSTRAINT task_owner_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_task_owner_report_id ON public.task_owner USING btree (report_id);


-- public.work_status definition

-- Drop table

-- DROP TABLE work_status;

CREATE TABLE work_status (
	id bigserial NOT NULL,
	workstatus_name text NULL,
	site_id int8 NULL,
	status int8 NULL,
	created_date timestamptz NULL,
	updated_date timestamptz NULL,
	created_at text NULL,
	updated_at text NULL,
	asset text NULL,
	CONSTRAINT work_status_pkey PRIMARY KEY (id)
);


-- public.focal_points definition

-- Drop table

-- DROP TABLE focal_points;

CREATE TABLE focal_points (
	id bigserial NOT NULL,
	inventory_id int8 NULL,
	inventory_extension_id int8 NULL,
	"name" text NOT NULL,
	asset text NULL,
	created_at timestamptz NULL,
	updated_at timestamptz NULL,
	CONSTRAINT focal_points_pkey PRIMARY KEY (id),
	CONSTRAINT fk_inventories_focal_points FOREIGN KEY (inventory_id) REFERENCES inventories(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_inventory_extensions_focal_points FOREIGN KEY (inventory_extension_id) REFERENCES inventory_extensions(id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- public.spare_images definition

-- Drop table

-- DROP TABLE spare_images;

CREATE TABLE spare_images (
	id bigserial NOT NULL,
	image_key text NULL,
	inventory_id int8 NOT NULL,
	caption text NULL,
	created_at timestamptz NULL,
	updated_at timestamptz NULL,
	CONSTRAINT spare_images_pkey PRIMARY KEY (id),
	CONSTRAINT fk_inventories_spare_images FOREIGN KEY (inventory_id) REFERENCES inventories(id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- public.transaction_groups definition

-- Drop table

-- DROP TABLE transaction_groups;

CREATE TABLE transaction_groups (
	id bigserial NOT NULL,
	"date" timestamptz NULL,
	"type" public."transaction_types" NOT NULL,
	dan_mmr text NULL,
	wo_tag text NULL,
	po_tag text NULL,
	owner_name text NOT NULL,
	detail text NULL,
	created_at timestamptz NULL,
	updated_at timestamptz NULL,
	report_id int4 NULL,
	CONSTRAINT transaction_groups_pkey PRIMARY KEY (id),
	CONSTRAINT fk_transaction_groups_report_id FOREIGN KEY (report_id) REFERENCES daily_reports(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX idx_transaction_groups_report_id ON public.transaction_groups USING btree (report_id);


-- public.transaction_items definition

-- Drop table

-- DROP TABLE transaction_items;

CREATE TABLE transaction_items (
	id bigserial NOT NULL,
	group_id int8 NOT NULL,
	material_no text NOT NULL,
	quantity int8 NOT NULL,
	plant text NULL,
	"location" text NULL,
	shelf text NULL,
	container text NULL,
	created_at timestamptz NULL,
	updated_at timestamptz NULL,
	CONSTRAINT transaction_items_pkey PRIMARY KEY (id),
	CONSTRAINT fk_transaction_groups_items FOREIGN KEY (group_id) REFERENCES transaction_groups(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX idx_transaction_items_group_id ON public.transaction_items USING btree (group_id);
