/* Script for MS SQL to make the DB tables needed for CrushFTP. */
/* http://www.crushftp.com/crush9wiki/Wiki.jsp?page=MSSQL */

-- Users --

CREATE TABLE DOMAIN_ROOT_LIST (
  userid int NOT NULL default '0',
  domain varchar(MAX) default NULL,
  path varchar(MAX) default NULL,
  sort_order int default NULL
)

CREATE TABLE EVENTS5 (
  userid int NOT NULL default '0',
  event_name varchar(MAX) NOT NULL default '',
  prop_name varchar(MAX) NOT NULL default '',
  prop_value text NOT NULL
)

CREATE TABLE INHERITANCE (
  userid int default NULL,
  inherit_username varchar(MAX) default NULL,
  server_group varchar(MAX) default NULL,
  sort_order int default NULL
)

CREATE TABLE IP_RESTRICTIONS (
  userid int NOT NULL default '0',
  start_ip varchar(MAX) default NULL,
  type varchar(1) default NULL,
  stop_ip varchar(MAX) default NULL,
  sort_order int default NULL
)

CREATE TABLE USER_PROPERTIES (
  userid int default NULL,
  prop_name varchar(MAX) default NULL,
  prop_value varchar(MAX) default NULL
)

CREATE TABLE USERS (
  userid int NOT NULL IDENTITY (1, 1) NOT FOR REPLICATION,
  username varchar(MAX) default NULL,
  password varchar(MAX) default NULL,
  server_group varchar(MAX) default NULL,
  PRIMARY KEY  (userid)
)

CREATE TABLE VFS (
  userid int default NULL,
  url varchar(MAX) default NULL,
  type varchar(MAX) default NULL,
  path varchar(MAX) default NULL,
  sort_order int default NULL
)

CREATE TABLE VFS_PERMISSIONS (
  userid int default NULL,
  path varchar(MAX) default NULL,
  privs varchar(MAX) default NULL
)

CREATE TABLE WEB_BUTTONS (
  userid int NOT NULL default '0',
  sql_field_key varchar(MAX) default NULL,
  sql_field_value varchar(MAX) default NULL,
  for_menu varchar(MAX) default NULL,
  for_context_menu varchar(MAX) default NULL,
  sort_order int default NULL
)

CREATE TABLE WEB_CUSTOMIZATIONS (
  userid int NOT NULL default '0',
  sql_field_key varchar(MAX) default NULL,
  sql_field_value varchar(MAX) default NULL,
  sort_order int default NULL
)

CREATE TABLE GROUPS (
  groupname varchar(MAX) default NULL,
  userid int default NULL,
  server_group varchar(MAX) default NULL
)

CREATE TABLE MODIFIED_TIMES (
  server_group varchar(MAX) default NULL,
  prop_name varchar(MAX) default NULL,
  prop_value varchar(MAX) default NULL
)

CREATE TABLE VFS_PROPERTIES (
  userid int default NULL,
  path varchar(MAX) default NULL,
  prop_name varchar(MAX) default NULL,
  prop_value varchar(MAX) default NULL
)

-- Search --

CREATE TABLE SEARCH_INFO (
  ITEM_PATH varchar(1000) default NULL,
  ITEM_TYPE varchar(10) default NULL,
  ITEM_SIZE varchar(20) default NULL,
  ITEM_MODIFIED varchar(20) default NULL,
  ITEM_KEYWORDS varchar(2000) default NULL
)

-- Sync --

CREATE TABLE FILE_JOURNAL (
  RID FLOAT NOT NULL PRIMARY KEY,
  SYNC_ID VARCHAR(255) NOT NULL,
  ITEM_PATH VARCHAR(2000) NOT NULL,
  EVENT_TYPE VARCHAR(20) NOT NULL,
  EVENT_TIME DATETIME2(0) NOT NULL,
  CLIENTID VARCHAR(20) NOT NULL,
  PRIOR_MD5 VARCHAR(50) NOT NULL
)

-- Stats --

CREATE TABLE META_INFO (
  RID BIGINT NOT NULL PRIMARY KEY,
  SESSION_RID BIGINT NOT NULL,
  TRANSFER_RID BIGINT NOT NULL,
  ITEM_KEY VARCHAR(100) DEFAULT NULL,
  ITEM_VALUE VARCHAR(2000) DEFAULT NULL
)

CREATE TABLE [SESSIONS] (
  RID BIGINT NOT NULL PRIMARY KEY,
  [SESSION] VARCHAR(100) DEFAULT NULL,
  SERVER_GROUP VARCHAR(50) DEFAULT NULL,
  [USER_NAME] VARCHAR(100) DEFAULT NULL,
  START_TIME DATETIME DEFAULT NULL,
  END_TIME DATETIME DEFAULT NULL,
  SUCCESS_LOGIN VARCHAR(10) DEFAULT NULL,
  [IP] VARCHAR(50) DEFAULT NULL
)

CREATE TABLE TRANSFERS (
  RID BIGINT NOT NULL PRIMARY KEY,
  SESSION_RID BIGINT NOT NULL,
  START_TIME DATETIME DEFAULT NULL,
  DIRECTION VARCHAR(8) DEFAULT NULL,
  [PATH] VARCHAR(255) DEFAULT NULL,
  [FILE_NAME] VARCHAR(2000) DEFAULT NULL,
  [URL] VARCHAR(2000) DEFAULT NULL,
  SPEED INTEGER DEFAULT NULL,
  TRANSFER_SIZE BIGINT DEFAULT NULL,
  IGNORE_SIZE VARCHAR(1) DEFAULT NULL
)