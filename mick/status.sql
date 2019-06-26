SET line 1000
set pagesize 1000
spool C:\status.lst
select 'ALTER '||DECODE(OBJECT_TYPE,'PACKAGE BODY','PACKAGE',OBJECT_TYPE)||' '||OBJECT_NAME||' COMPILE '||DECODE(OBJECT_TYPE,'PACKAGE BODY','BODY;',';') "Objects"
FROM USER_OBJECTS 
WHERE STATUS='INVALID'
AND object_name like Upper('&object')||'%'
/
spool off
