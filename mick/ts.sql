
set linesize 100
col Total format 99999.99 heading "Total space(MB)"
col Used format 99999.99 heading "Used space(MB)"
col Free format 99999.99 heading "Free space(MB)"
break on report
compute sum of Total space(MB) on report
compute sum of Used space(MB) on report
compute sum of Free space(MB) on report
select a.tablespace_name, round(a.bytes/1024/1024,2) Total,
round( nvl( b.bytes,0)/1024/1024,2) Used,
round(nvl(c.bytes, 0)/1024/1024,2) Free ,
round(nvl(b.bytes,0)*100/nvl(a.bytes,0),2) "% Used"
from sys.sm$ts_avail a, sys.sm$ts_used b, sys.sm$ts_free c
where a.tablespace_name=b.tablespace_name(+)
and b.tablespace_name=c.tablespace_name(+);
clear breaks
clear columns
set verify on
spool off


