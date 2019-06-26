SELECT function_id,err_code,message FROM ertb_msgs
 WHERE FUNCTION_ID=UPPER('&function_id')
/
