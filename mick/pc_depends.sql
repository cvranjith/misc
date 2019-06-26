set serverout on size 1000000
set line 999
set pages 999
set feed off
set trimspoo on

spo c:\pc_dep.txt


select 'name'||'~'||'type'||'~'||'referenced_name'||'~'||'referenced_type'||'~'||'dependency_type' from
dual
/

select name||'~'||type||'~'||referenced_name||'~'||referenced_type||'~'||dependency_type from
user_dependencies where
name like 'PC%'
and type in ('PACKAGE','PACKAGE BODY')
and instr(name,'#') = 0
order by name,type
/

spo off
