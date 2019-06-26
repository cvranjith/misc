set verify off
select table_name, column_name,DATA_TYPE||'('||DATA_LENGTH||')' data_type
from cols where column_name like 
REPLACE(upper('%&COLUMN%'),' ','%')
AND TABLE_NAME LIKE REPLACE(upper('%&TAB%'),' ','%')
/
set verify on
