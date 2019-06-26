select ltrim(rtrim(substr(machine,1,15))),ltrim(rtrim(substr(program,1,15))),
ltrim(rtrim(substr(action,1,15))),  ltrim(rtrim(a.sid)) , 
ltrim(rtrim(b.serial#))
from v$lock a,v$session b where a.sid = b.sid
and a.lmode = 3
and
b.username ='&schema'
/
