SELECT 	substr(b.object_name,1,36),
		a.locked_mode,
		a.session_id,
		c.osuser,
		c.machine
FROM 		v$locked_object a,
		all_objects b,
		v$session c
WHERE		b.object_id = a.object_id
AND			c.sid = a.session_id
AND		c.username = 'FCCDEVMAIN'
and		b.object_name like upper('%&obj_name%')
/
