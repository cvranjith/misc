SET TRIMSPOOL ON PAGES 0 LINE 9999 FEED OFF TERMOUT OFF
SPOOL TMP.TMP
SELECT distinct 'ALTER TABLE FLXT.'||TABLE_NAME||' DIsABLE ALL TRIGGERS;' from user_triggers;
SPOOL OFF
set feed on TERMOUT ON
