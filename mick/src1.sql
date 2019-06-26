store set /tmp/store.set replace
set feed off verify off pages 0 line 999 trimspo on long 2000000000
undef object_name otyp object_type spofn

define object_name = &1
define file_name_tag = &2

col object_type new_value object_type
select lower(object_type) object_type from user_objects b where object_name = upper('&&object_name') and object_type != 'PACKAGE BODY'; 

col spofn new_value spofn
select '/tmp/'||global_name||'.'||user||'.&&file_name_tag..'||lower('&&object_name')||'.'||
        decode(
        '&&object_type'
        ,'package'      ,'sql'
        ,'trigger'      ,'trg'
        ,'function'     ,'fnc'
        ,'procedure'    ,'prc'
        ,'view'         ,'vw'
        ,null           ,'invalid_object'
                        ,'ddl') spofn
from global_name;

set termout off
spo &spofn
select   decode(line,1,decode(type,'PACKAGE BODY','/'||chr(10),null)||'CREATE OR REPLACE ',null)||rtrim(text,chr(10))
from     user_source
where    name = upper ('&&object_name')
and      '&&object_type' in ('function','procedure','package')
order by type,line;
select '/' from dual where '&&object_type' in ('function','procedure','package');
col ddl form a50000
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SQLTERMINATOR',true);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'STORAGE',false);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'PRETTY',true);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'TABLESPACE',false);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SEGMENT_ATTRIBUTES',false);
select ltrim(ltrim(replace(dbms_metadata.get_ddl(upper('&&object_type'),upper('&&object_name')),'"'||user||'".'),chr(10))) ddl from dual where '&&object_type' not in ('function','procedure','package');
prompt
select '--generated from '||user||' @ '||global_name||' at '||to_char(sysdate,'dd-mon-rrrr:hh24:mi:ss') from global_name;
spo off
undef object_name object_type file_name_tag 1 2
@/tmp/store.set

