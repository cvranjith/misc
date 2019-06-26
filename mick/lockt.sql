SELECT 	substr(b.object_name,1,30) object, a.session_id, c.status, substr(c.username,1,10) username, substr(c.osuser,1,10) osuser, substr(c.terminal,1,10) terminal, a.locked_mode
FROM 	v$locked_object a,
	user_objects b,
	v$session c
WHERE	b.object_id = a.object_id
AND	a.session_id = c.sid
AND	B.OBJECT_NAME LIKE REPLACE(upper('%&TNAME%'),' ','%')
/
