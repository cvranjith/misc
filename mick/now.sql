col curr_time form a50
select 
'Singapore Time : '||to_char(sysdate,'DD-MON-YYYY HH12:MI:SS AM')||chr(10)||
'Paris Time     : '||to_char(sysdate-7/24,'DD-MON-YYYY HH12:MI:SS AM') ||chr(10)||
'India Time     : '||to_char(sysdate-2.5/24,'DD-MON-YYYY HH12:MI:SS AM') curr_time
from dual
/
