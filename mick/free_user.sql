select sum(bytes)/1024/1024, tablespace_name from user_free_space
group by tablespace_name
/
