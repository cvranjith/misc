SET TRIMSPOOL ON PAGES 0 LINE 9999 FEED OFF termout off
SPOOL /tmp/trunc_FLXOHKG.sql
SELECT 'ALTER TABLE FLXOHKG.'||TABLE_NAME||' DISABLE CONSTRAINT '||CONSTRAINT_NAME||';'
FROM USER_CONSTRAINTS where table_name not like 'BIN%';
SELECT distinct 'ALTER TABLE FLXOHKG.'||TABLE_NAME||' DIsABLE ALL TRIGGERS;' from user_triggers
where table_name not like 'BIN%';
SELECT 'TRUNCATE TABLE FLXOHKG.'||TABLE_NAME||' ;' from user_tables where table_name not in (select * from tmp_trunc);
SPOOL OFF
set feed on
