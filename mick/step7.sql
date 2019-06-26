set head off
set feed off
set pages 0
set linesize 255
set trimspool on 
spool enable_constraints.sql 
select 'Alter Table ' || table_name ||' enable constraint ' || constraint_name || ';' from user_constraints where status = 'DISABLED';
spool off
set feed on
spool see_step7.sql
@enable_constraints
spool off
