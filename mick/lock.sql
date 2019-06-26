col object_name form a30
--col session_id form a15
col status form a8
col username form a15
col osuser form a15
col terminal form a10
col machine form a15
--col locked_mode form a15
col module form a15
set line 999
SELECT 	b.object_name, a.session_id, c.serial#, c.status, c.username, c.osuser, c.terminal, machine, a.locked_mode,module
FROM 	v$locked_object a,
	dba_objects b,
	v$session c
WHERE	b.object_id = a.object_id
AND	a.session_id = c.sid
/
