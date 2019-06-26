
set pagesize 1000
set linesize 132
column sql_text format a60
SELECT * FROM (SELECT sql_text,module,to_char(sharable_mem/1024,'9,999.9') "SPACE(K)",executions
FROM V$SQLAREA WHERE sharable_mem > 1048
ORDER BY sharable_mem DESC) WHERE rownum <= 10;

