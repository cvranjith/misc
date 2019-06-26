SELECT /*+ ORDERED */ 
	o.owner OWNER, 
	o.object_name NAME, 
	o.object_type TYPE, 
	o.object_id ID 
FROM	public_dependency d,
	ALL_OBJECTS o,
	ALL_OBJECTS r
WHERE	r.object_name = upper('&OBJECT')
AND	d.referenced_object_id = r.object_id
AND	o.object_id = d.object_id
/
