set pause off
set head off
set feedback off
set pages 30000
spool dis_triggers.sql
select 'Alter table '|| TABLE_NAME ||' disable all triggers ;' from user_triggers ; 
spool off
set feedback on
spool se_ep1.sql
@dis_triggers
spool off

