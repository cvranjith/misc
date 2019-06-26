select terminal,osuser from v$session where sid in
   (select session_id from dba_ddl_locks where owner='FCCLATAM' and name='IFPKS_XML_PROC');
