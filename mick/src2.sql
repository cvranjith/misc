@storeset
set feed off verify off pages 0 line 999 trimspo on long 2000000000
undefine object_name otyp object_type spofn

prompt Enter value for object_name:
set termout off
define object_name = &1
set termout on

col otyp new_value otyp
select object_type otyp from user_objects b where object_name = upper('&&object_name') and 1 = (select count(1) from user_objects a where a.object_name = b.object_name);
set termout off
define object_type = &&otyp
set termout on

prompt &&object_name
prompt &&object_type


col spofn new_value spofn
select '/tmp/'||lower('&&object_name')||'.'||
        decode(
        nvl(lower('&&object_type'),(select lower(object_type) from user_objects where object_name = upper('&&object_name') and object_type != 'PACKAGE'))
        ,'package'      ,'spc'
        ,'trigger'      ,'trg'
        ,'function'     ,'fnc'
        ,'procedure'    ,'prc'
        ,'package body' ,'sql'
        ,null           ,'invalid_object'
                        ,'ddl') spofn
from dual;

set termout off
spo &spofn
select   decode(line,1,'CREATE OR REPLACE ',null)||rtrim(text,chr(10))
from     user_source
where    name = upper ('&&object_name')
and      (
             ('&&object_type' is not null and type = upper('&object_type'))
         or  ('&&object_type' is null and type != 'PACKAGE')
         )
and      nvl(lower('&&object_type'),'package body') in ('function','procedure','package','package body')
order by line;
select '/' from dual where nvl(lower('&&object_type'),'package body') in ('function','procedure','package','package body');
col ddl form a50000
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SQLTERMINATOR',true);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'STORAGE',false);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'PRETTY',true);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'TABLESPACE',false);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SEGMENT_ATTRIBUTES',false);
select ltrim(ltrim(replace(dbms_metadata.get_ddl(upper('&&object_type'),upper('&&object_name')),'"'||user||'".'),chr(10))) ddl from dual where nvl(lower('&&object_type'),'package body') not in ('function','procedure','package','package body');
prompt
select '--generated from '||user||' @ '||global_name||' at '||to_char(sysdate,'dd-mon-rrrr:hh24:mi:ss') from global_name;
spo off
undefine object_name otyp object_type 1
@restoreset
