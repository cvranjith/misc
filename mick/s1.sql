
@storeset
set feed off verify off pages 0 line 999 trimspo on long 2000000000 time off timing off
undefine object_name otyp object_type spofn swrp

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
        ,'view'         ,'vw'
        ,null           ,'invalid_object'
                        ,'ddl') spofn
from dual;

col swrp new_value swrp
select  decode(instr(lower(text),'wrapped'),0,'n','y') swrp
from    user_source
where    name = upper ('&&object_name')
and      (
             ('&&object_type' is not null and type = upper('&object_type'))
         or  ('&&object_type' is null and type != 'PACKAGE')
         )
and      nvl(lower('&&object_type'),'package body') in ('function','procedure','package','package body')
and     line = 1;

set termout off
spo &spofn
select   decode(line,1,'CREATE OR REPLACE ',null)||rtrim(text,chr(10))
--select   rtrim(text,chr(10))
from     user_source
where    name = upper ('&&object_name')
and      (
             ('&&object_type' is not null and type = upper('&object_type'))
         or  ('&&object_type' is null and type != 'PACKAGE')
         )
and      nvl(lower('&&object_type'),'package body') in ('function','procedure','package','package body')
and      nvl('&&swrp','n') = 'n'
order by line;
select '/' from dual where nvl(lower('&&object_type'),'package body') in ('function','procedure','package','package body') and nvl('&&swrp','n') = 'n';

--col ddl form a50000
col ddl form a60000 word_wrapped
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SQLTERMINATOR',true);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'STORAGE',false);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'PRETTY',true);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'TABLESPACE',false);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SEGMENT_ATTRIBUTES',false);
select ltrim(ltrim(replace(dbms_metadata.get_ddl(upper('&&object_type'),upper('&&object_name')),'"'||user||'".'),chr(10))) ddl from dual where nvl(lower('&&object_type'),'package body') not in ('function','procedure','package','package body');
prompt
select '--generated from '||user||' @ '||global_name||' at '||to_char(sysdate,'dd-mon-rrrr:hh24:mi:ss') from global_name;
spo off

declare
w varchar2(1) := '&&swrp';
f utl_file.file_Type;
r varchar2(10000);
t varchar2(10000);
begin
f := utl_file.fopen(global.work_area,'swrp.tmp','w',32767);
if w = 'y'
then
for i in(
select   rtrim(text,chr(10)) t
from     user_source
where    name = upper ('&&object_name')
and      (
             ('&&object_type' is not null and type = upper('&object_type'))
         or  ('&&object_type' is null and type != 'PACKAGE')
         )
and      nvl(lower('&&object_type'),'package body') in ('function','procedure','package','package body')
order by line
)
loop
    
    t := r||substr(i.t,1, instr(i.t,chr(10),-1)-1);
    r := substr(i.t,instr(i.t,chr(10),-1)+1);
    if length(r) = 72 then r := r||chr(10); end if;
    utl_file.put_line(f,t);
end loop;
utl_file.put_line(f,r);
end if;
utl_file.fclose(f);
end;
/

col gwa new_value gwa
select rtrim(directory_path,'/') gwa from all_directories where directory_name = global.work_area;
!./unwrap.py &&gwa/swrp.tmp >> &&spofn
undefine object_name otyp object_type 1
@restoreset


