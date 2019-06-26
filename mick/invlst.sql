COLUMN OBJECT_NAME FORMAT A30 ;
Select object_type, object_name from user_objects where
status = 'INVALID'
order by object_type, object_name
/
