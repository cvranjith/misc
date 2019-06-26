select sum(bytes)/1024/1024, tablespace_name from dba_free_space
group by tablespace_name
/
