set linesize 10000
set array 1
set head on
set pagesize 10000
set long 10000
set trimspool on
spool c:\index_spool.sql

SELECT table_name,index_name,column_position,column_name 
FROM   user_ind_columns 
WHERE  table_name in
('GLTB_GL_BAL','GLTM_GLMASTER','STTM_CUST_ACCOUNT','ACTB_ACCBAL_HISTORY','ACTB_DAILY_LOG',
'ACTB_HISTORY','ACTB_VD_BAL','ACTB_VD_BAL_MISMATCH','STTM_BANK','STTM_BRANCH','GLTB_CUST_ACC_BREAKUP',
'STTM_PERIOD_CODES','GLTB_MISMATCH','GLTB_MISMATCH_MOV','STTM_FIN_CYCLE','STTM_ACCOUNT_CLASS')
ORDER BY table_name,index_name,column_position ;

spool off