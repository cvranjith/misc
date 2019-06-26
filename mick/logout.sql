set head off
set pages 0
set feed off
set trimspool on
spool c:\logout.bat

select distinct
'NET SEND ' || substr(machine,instr(machine, '\')+1) || ' Pls log out of ' || username
from v$session where username = (select username from user_users)
/

spo off
set pages 100
set head on
set feed on

host c:\logout.bat
host del c:\logout.bat
