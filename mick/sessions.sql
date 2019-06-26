set line 200
select sid, serial#, substr(machine,1,50) machine, process,
   substr(program,1,10) program, substr(osuser, 1, 30) osuser,
   substr(module,1,30) module
from v$session where username = (select username from user_users)
order by 5
/
set line 80
