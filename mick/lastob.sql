@storeset
set line 9999
col object_name form a35
col object_type form a20
select * from
(select object_name,object_type,to_char(last_ddl_time,'DD-MON-RRRR HH24:MI:SS') last_ddl_time from user_objects order by last_ddl_time desc)
where rownum <= nvl('&rows',10)
/
@restoreset

