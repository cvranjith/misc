set verify off
set head off
set feed off
set pages 999

create table temp_depend (object_id,referenced_object_id) as
select d.d_obj#, d.p_obj# from dependency$ d
where d.d_obj# in (select object_id from dba_objects
      where owner = '&&uname'
  and object_type in ('FUNCTION', 'PROCEDURE', 'PACKAGE', 'PACKAGE BODY', 'VIEW'
, 'TRIGGER') and status='INVALID')
/

create or replace view ord_obj_by_depend (dlevel, object_id) as
select max(level), object_id from temp_depend
connect by object_id = prior referenced_object_id
group by object_id
/

 –spool &filename
spool compile.sql

select
decode(OBJECT_TYPE, 'PACKAGE BODY',
'alter package ' || OWNER||'.'||OBJECT_NAME || ' compile body;',
'alter ' || OBJECT_TYPE || ' ' || OWNER||'.'||OBJECT_NAME || ' compile;')
from dba_objects a, ord_obj_by_depend b
where a.owner = upper('&&uname') and
status='INVALID'
and
A.OBJECT_ID = B.OBJECT_ID(+) and
OBJECT_TYPE in ('PACKAGE BODY', 'PACKAGE', 'FUNCTION', 'PROCEDURE', 'TRIGGER',
VIEW')
order by DLEVEL DESC, OBJECT_TYPE, OBJECT_NAME;
spool off

PROMPT
PROMPT COMPILING INVALID OBJECTS
PROMPT
@compile.sql
drop view ord_obj_by_depend;
drop table temp_depend;

undef uname
set head on
set feed on
set pages 24
set verify on
