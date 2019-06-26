col tablespace form a20
select d.t "Tablespace",d.s "Total Space",nvl(round(f.s),0) "Free Space"
from
(select a.tablespace_name t, sum(a.bytes/1024/1024) s from dba_data_files a group by a.tablespace_name
union
select tablespace_name, sum(bytes/1024/1024) from dba_temp_files group by tablespace_name
) d,
(select a.tablespace_name t, sum(a.bytes/1024/1024) s from dba_free_space a group by a.tablespace_name
union
select tablespace_name, sum(BYTES_FREE/1024/1024) from  V$TEMP_SPACE_HEADER group by tablespace_name
) f
where d.t = f.t (+)
/
