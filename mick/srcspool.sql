prompt &1 &2 &3
set termout off
declare
x varchar2(1000) := lower('&2');
begin
if x != 'package' then
pr_unwrap('&1');
end if;
end;
/

spo /home/iflex/src/&3
select 'create or replace' from dual where lower('&2') in ('function','procedure','package','packagebody');
select   text
from     user_source
where    name = upper ('&1')
and      replace(type,' ') = '&2'
order by line;
select '/' from dual where lower('&2') in ('function','procedure','package','packagebody');
col ddl form a50000
select ltrim(ltrim(replace(dbms_metadata.get_ddl(upper('&2'),upper('&1')),'"'||user||'".'),chr(10))) ddl from dual where lower('&2') not in ('function','procedure','package','packagebody');
prompt
spo off
set termout on


