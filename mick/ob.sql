col object_name form a30
col object_type form a30
col status form a10
SELECT OBJECT_NAME, OBJECT_TYPE,status OBJECT FROM
USER_OBJECTS WHERE OBJECT_NAME LIKE REPLACE(upper('%&OB%'),' ','%')
/
 
