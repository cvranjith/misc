undefine sid
DECLARE
SL NUMBER;
ID NUMBER := &SID;
BEGIN
SELECT SERIAL# INTO SL FROM V$SESSION WHERE SID = ID;
dbms_system.set_sql_trace_in_session(ID,SL,false);
END;
/
undefine sid