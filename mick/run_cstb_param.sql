set echo off feedback off timing off pause off verify off termout off
spool cstb_param.csv
SELECT	'"'||PARAM_NAME||'"'
	||','||'"'||PARAM_VAL||'"'
from	cstb_param
/
spool off
