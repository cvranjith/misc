set pause off
set head off
set feedback off
set pages 30000
set linesize 255
set trimspool on 
spool ena_triggers.sql
select 'Alter table '|| TABLE_NAME ||' enable all  triggers ;' from user_triggers ; 
spool off
set feed on
spool see_tep6.sql
@ena_triggers
spool off

