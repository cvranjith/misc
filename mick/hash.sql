SELECT     a.locked_mode, a.session_id, c.status,c.username, c.osuser, c.terminal,b.object_name,d.sql_text
FROM       v$locked_object a,
   user_objects b,
   v$session c,
	v$sql d
WHERE      b.object_id = a.object_id
AND        a.session_id = c.sid
AND	   c.sql_address = d.address

/
