SELECT OWNER,RPAD(OBJECT_NAME,30,' ') ||'  -  '|| OBJECT_TYPE OBJECT FROM
ALL_OBJECTS WHERE OBJECT_NAME LIKE REPLACE(upper('%&OB%'),' ','%')
/
