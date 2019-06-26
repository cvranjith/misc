set serveroutput on;
set line 999;

select sid,serial#,machine,schemaname from v$session
where sid in (select sid from v$lock)
/


