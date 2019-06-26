undefine sid
set head off
set verify off
set feed off
ACCEPT sid number PROMPT 'Enter the SID ==> '
spool tmp.k.cvr
select 'alter system kill session '||chr(39)||sid||','||serial#||chr(39)||';'
from v$session where sid = &sid
/
spool off
@tmp.k.cvr
undefine sid
set head on
set verify on
