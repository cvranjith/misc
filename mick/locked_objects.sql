SELECT 	b.object_name, a.locked_mode, a.session_id
FROM 	v$locked_object a,
	user_objects b
WHERE	b.object_id = a.object_id
/
