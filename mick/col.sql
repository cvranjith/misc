set verify off
select table_name, column_name
from cols where column_name like 
REPLACE(upper('%&COLUMN%'),' ','%')
/
set verify on
