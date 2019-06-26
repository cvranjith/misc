set line 200
select substr(machine,1,50) machine,substr(osuser, 1, 30) osuser, count(1) cnt
from v$session where username = (select username from user_users)
group by substr(machine,1,50), substr(osuser, 1, 30)
UNION
select 'ALL','ALL',count(1) cnt
from v$session where username = (select username from user_users)
order by 3 desc,2 asc
/
set line 80
