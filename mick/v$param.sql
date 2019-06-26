select name,value from v$parameter where upper(name) like upper('%&Param%')
/
