set pagesize 1000
set linesize 132
column sql_text format a60
select B.sql_text "Query",ROWS_PROCESSED,A.inst_id "Instance",A.sid "Sid",A.serial# "Serial
No.",A.machine "Machine",A.terminal "Terminal", A.program "Program",B.users_executing "Users"
,C.opname "Operation",C.target "Target", C.sofar "Till Now",C.totalwork "Total Work",C.Time_Remaining
"Remaining Time",C.elapsed_seconds "Time Taken",C.Message "Message", A.username "User",A.status
"Status" , LOGON_TIME, sysdate "Time" from gv$session A,gv$sql B,gv$session_longops C
where A.sql_address = B.address and B.users_executing > 0
--and c.totalwork<>c.sofar
and C.inst_id(+) = A.inst_id and C.sid(+) = A.sid
and C.serial#(+) = A.serial# and C.sql_address(+) = A.sql_address
--and Status NOT IN ('INACTIVE','KILLED');
/


