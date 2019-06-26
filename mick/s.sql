spool sessdets.lst
set pages 200

col name form a30
col username form a12
col sid form 999
col owner form a12
col object form a20
col type form a10

prompt
prompt Objects Accessed per Session
prompt 

select a.sid, a.username, b.*
from v$session a, v$access b
where a.sid = b.sid
order by a.sid
/
prompt
prompt Memory per Session
prompt

select a.sid, a.username, c.name, b.value
from v$session a, v$sesstat b, v$statname c
where a.sid = b.sid
and b.statistic# = c.statistic#
and c.name like 'session%memory'
order by a.sid
/
spool off
