SET TRIMSPOOL ON PAGES 0 LINE 999
SPO TMP.TMP
SELECT 'ANALYZE TABLE '||TABLE_NAME||' COMPUTE STATISTICS;' FROM USER_TABLES
WHERE TABLE_NAME NOT LIKE '%$%'
/
SPO OFF
