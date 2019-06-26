select a.tablespace_name, sum(a.bytes/1024/1024) free_space
from
dba_free_space a
group by a.tablespace_name
/
