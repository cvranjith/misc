select pool, name, round(bytes/(1024*1024)) "MB" from v$sgastat where name = 'free memory';
select pool, round(sum(bytes)/(1024*1024)) "Total SGA" from v$sgastat group by pool;
select round(sum(bytes)/(1024*1024)) "Total SGA" from v$sgastat;

col value form 999,999,999,999 heading "Shared Pool Size"
col bytes form 999,999,999,999 heading "Free Bytes"
col percentfree form 999 heading "Percent Free"

spool freesga.lst

select  pool
        , to_number(v$parameter.value) value, v$sgastat.bytes, 
	decode(v$parameter.value,0,0,1)*(v$sgastat.bytes/decode(v$parameter.value,0,1,v$parameter.value))*100 percentfree
from 	v$sgastat, v$parameter
where	v$sgastat.name = 'free memory' and pool='shared pool'
and	v$parameter.name = 'shared_pool_size';

spool off 
