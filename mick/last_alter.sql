select object_name, object_type, to_char(last_ddl_time,'dd mon rrrr hh24 mi ss')
from user_objects
where last_ddl_time = (select max(last_ddl_time) from user_objects)
/
