set pause off
set head off
set feedback off
set pages 30000
set linesize 255
set trimspool on
spool dise_nopk.sql
select 'ALTER TABLE ' || TABLE_NAME || ' DROP CONSTRAINT ' || constraint_name
 || ';' from user_constraints where constraint_type='C';
select 'Alter table '|| TABLE_NAME ||' disable constraint '||
constraint_name || ' ;' from user_constraints where constraint_type = 'R'
and status <> 'DISABLED' ;
spool off
set feedback on
spool se_ep2.sql
@dise_nopk
spool off

