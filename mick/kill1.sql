undefine sid
ACCEPT sid number PROMPT 'Enter the SID ==> '
begin
for i in (
select sid,serial#  
from v$session where sid = &sid
)
loop
if fct_kill_session(i.sid,i.serial#) != 0
then
raise_application_error(-20001,'Er in kill ');
end if;
end loop;
end;
/
undefine sid

