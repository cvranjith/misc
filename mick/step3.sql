set pause off
set head off
set feedback off
set pages 30000
set linesize 255
set trimspool on
spool truncae_tables.sql
select 'truncate table  '|| TABLE_NAME ||' reuse storage;' from tabs ; 
spool off
set feedback on
spool se_ep3.sql
@truncae_tables
spool off 
