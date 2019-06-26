@@storeset

set trimspo on pages 0 line 9999 feed off termout off

spo dis.tmp

select 'alter table '||table_name||' disable constraint '||constraint_name||';'
from user_constraints where status = 'ENABLED';
select distinct 'alter table '||table_name||' disable all triggers;' from user_triggers
where status = 'ENABLED';

spo off

set feed on echo on time on timing on

spo off


@@restoreset

