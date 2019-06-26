set verify off
select * from CSTB_PARAM where PARAM_NAME like REPLACE(upper('%&PAR%'),' ','%')
/
set verify on
