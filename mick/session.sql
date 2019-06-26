SELECT 	c.sid, c.username, c.osuser, c.terminal,c.status, c.serial#
FROM 	v$session c
WHERE	c.status = 'ACTIVE'
and username is not null
/
