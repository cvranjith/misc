--alter session set plsql_optimize_level = 0;

set head off
set pause off
set feedback off
set pages 30000
spool TMP.TMP
select 'ALTER '|| decode (object_type, 'PACKAGE BODY', 'PACKAGE',object_type)
        || ' ' || object_name|| ' ' ||
    decode (object_type, 'PACKAGE BODY', 'COMPILE BODY;','COMPILE;')
from user_objects
where 
STATUS  = 'INVALID'
--and object_type = 'VIEW'
order by  object_type

/
spool off
set feedback on
@TMP.TMP
set pause off 
set head on

@compinv
@comipnv

