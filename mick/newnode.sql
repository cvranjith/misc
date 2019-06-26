DECLARE
	l_old_node	varchar2(32) ;	
	l_new_node	varchar2(32) ;
BEGIN

dbms_output.put_line ('Processing starts----> ') ;

l_old_node := UPPER('&old_database') ;
l_new_node := UPPER('&new_database') ;

UPDATE ACTB_DAILY_LOG SET NODE = L_NEW_NODE
	WHERE NODE = L_OLD_NODE ;
dbms_output.put_line('Processing Succesful1') ;
UPDATE BKTB_SCHEMA_DEFAULTS SET NODE = L_NEW_NODE
	WHERE NODE = L_OLD_NODE ;
dbms_output.put_line('Processing Succesful2') ;
UPDATE CSTB_NODE_PARAMS SET NODE = L_NEW_NODE
	WHERE NODE = L_OLD_NODE ;
dbms_output.put_line('Processing Succesful3') ;
UPDATE DSTB_MAINT SET NODE = L_NEW_NODE
	WHERE NODE = L_OLD_NODE ;
dbms_output.put_line('Processing Succesful4') ;
UPDATE ICTB_ACC_ACTION SET NODE = L_NEW_NODE
	WHERE NODE = L_OLD_NODE ;
dbms_output.put_line('Processing Succesful5') ;
UPDATE ICTB_ACTION_LOG SET NODE = L_NEW_NODE
	WHERE NODE = L_OLD_NODE ;
dbms_output.put_line('Processing Succesful6') ;
UPDATE ICTB_RESOLUTION_ERROR SET NODE = L_NEW_NODE
	WHERE NODE = L_OLD_NODE ;
dbms_output.put_line('Processing Succesful7') ;
UPDATE LMTB_OFFLINE_NODES SET NODE_NAME = L_NEW_NODE
	WHERE NODE_NAME = L_OLD_NODE ;
dbms_output.put_line('Processing Succesful8') ;
UPDATE LMTB_OFFLINE_UTILS SET NODE_NAME = L_NEW_NODE
	WHERE NODE_NAME = L_OLD_NODE ;
dbms_output.put_line('Processing Succesful9') ;
UPDATE MSTB_CURRENT_MSG_IND_OUT SET NODE = L_NEW_NODE
	WHERE NODE = L_OLD_NODE ;
dbms_output.put_line('Processing Succesful10') ;
UPDATE MSTB_DLY_MSG_IN SET NODE = L_NEW_NODE
	WHERE NODE = L_OLD_NODE ;
dbms_output.put_line('Processing Succesful11') ;
UPDATE MSTB_DLY_MSG_OUT SET NODE = L_NEW_NODE
	WHERE NODE = L_OLD_NODE ;
dbms_output.put_line('Processing Succesful12') ;
UPDATE MSTM_MCS SET NODE = L_NEW_NODE
	WHERE NODE = L_OLD_NODE ;
dbms_output.put_line('Processing Succesful13') ;
UPDATE MSTM_UNDO SET NODE = L_NEW_NODE
	WHERE NODE = L_OLD_NODE ;
dbms_output.put_line('Processing Succesful14') ;
UPDATE STTM_BRANCH_NODE SET NODE = L_NEW_NODE
	WHERE NODE = L_OLD_NODE ;
dbms_output.put_line('Processing Succesful15') ;
UPDATE STTM_BRANCH SET HOST_NAME = L_NEW_NODE
	WHERE HOST_NAME = L_OLD_NODE ;
dbms_output.put_line('Processing Succesful16') ;
UPDATE STTM_CUSTOMER SET LIAB_NODE = L_NEW_NODE
	WHERE LIAB_NODE = L_OLD_NODE ;
dbms_output.put_line('Processing Succesful17') ;
dbms_output.put_line('Processing Succesful') ;
dbms_output.put_line('*****************************') ;
dbms_output.put_line('*******No Commit Done********') ;
dbms_output.put_line('*****************************') ;

EXCEPTION
	WHEN OTHERS
	THEN
	dbms_output.put_line('Failed for :'||SQLERRM) ;
END ;
/
