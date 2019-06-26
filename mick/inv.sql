col object_type form a20
col object_name form a30
select object_type, object_name from user_objects 
where status = 'INVALID'
/
