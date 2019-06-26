select
c.object_name ,
b.osuser,
b.username ,
a.locked_mode ,
b.serial#,
b.sid
from
v$locked_object a,v$session b, all_objects c
where a.session_id = b.sid and
a.object_id = c.object_id
AND b.userName   = 'FCC45'
/