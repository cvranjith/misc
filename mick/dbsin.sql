SELECT 	sid,status,schemaname,sql_text
FROM 	v$session c,
 	v$sql d
WHERE	c.sql_address = d.address
AND     c.schemaname  = 'FCDBSIN'
/
