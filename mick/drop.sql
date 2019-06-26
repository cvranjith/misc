set trimspool on pages 0 line 9999 feed off termout off
spool /tmp/tmp.tmp.1

select 'drop ' || object_type || ' "FLXOHKG"."' || object_name || '";'
from user_objects
where object_type not in ('INDEX','TRIGGER','PACKAGE BODY')
/

spool off

set feed on pages 100

alter session set recyclebin=off
/
