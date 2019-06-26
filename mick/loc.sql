SELECT 	ltrim(rtrim(substr(machine,1,30))) machine,
		ltrim(rtrim(substr(program,1,30))) program,
		ltrim(rtrim(substr(action,1,30))) action,  
		ltrim(rtrim(a.sid)) sid, 
		ltrim(rtrim(b.serial#)) serial
FROM 		v$lock a,
		v$session b 
WHERE 	a.sid = b.sid
AND 		a.lmode = 3
AND		b.username ='FCCBRANCH'
/
