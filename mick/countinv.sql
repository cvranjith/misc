select count(1), object_type from user_objects
WHERE STATUS = 'INVALID'
group by object_type
/
