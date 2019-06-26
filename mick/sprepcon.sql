Rem
Rem $Header: sprepcon.sql 14-oct-2003.15:46:36 cdialeri Exp $
Rem
Rem sprepcon.sql
Rem
Rem Copyright (c) 2001, 2003, Oracle Corporation.  All rights reserved.  
Rem
Rem    NAME
Rem      sprepcon.sql - StatsPack REPort CONiguration
Rem
Rem    DESCRIPTION
Rem      SQL*Plus command file which allows configuration of certain
Rem      aspects of the instance report
Rem
Rem    NOTES
Rem      To change the default settings, this file should be copied by
Rem      the user, then modified with the desired settings
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    cdialeri    10/14/03 - 10g - streams - rvenkate
Rem    cdialeri    10/07/03 - cdialeri_sp_10_f3 
Rem    cdialeri    08/06/03 - Created
Rem

Rem     -------------           Beginning of                -----------
Rem     ------------- Customer Configurable Report Settings -----------

--
-- Snapshot related report settings

-- The default number of days of snapshots to list when displaying the
-- list of snapshots to choose the begin and end snapshot Ids from.
--
--   List all snapshots
define num_days = '';
--
--   List last 31 days
-- define num_days = 31;
--
--   List no (i.e. 0) snapshots
-- define num_days = 0;


--
-- SQL related report settings

-- Number of Rows of SQL to display in each SQL section of the report
define top_n_sql = 65;

-- Number of rows of SQL Text to print in the SQL sections of the report
-- for each hash_value
define num_rows_per_hash = 4;

-- Filter which restricts the rows of SQL shown in the SQL sections of the 
-- report to be the top N pct
define top_pct_sql = 1.0;


--
-- Segment related report settings

-- The number of top segments to display in each of the High-Load Segment 
-- sections of the report
define top_n_segstat = 5;


--
-- File Histogram statistics related report settings
-- (whether or not to display histogram statistics in the report)

--  Do not print File Histogram stats
--define file_histogram = N;
--  Print file histogram stats
define file_histogram = 'Y';


--
-- Event Histogram statistics related report settings
-- (whether or not to display histogram statistics in the report)

--  Do not print Event Histogram stats
--define event_histogram = N;
--  Print Event histogram stats
define event_histogram = 'Y';



--
-- Streams related report settings
--
define streams_top_n = 25


Rem     -------------                End  of                -----------
Rem     ------------- Customer Configurable Report Settings -----------
