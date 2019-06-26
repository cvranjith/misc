SET SERVEROUT ON SIZE 1000000 VERIFY OFF
SET LINE 9999
UNDEF VAL
UNDEF BRN

ACCEPT VAL CHAR PROMPT 'Enter the Vostro account class ==> '
ACCEPT BRN CHAR PROMPT 'Enter the Branch code          ==> '

DECLARE
	l_rid		ROWID;
BEGIN
	BEGIN
		SELECT	rowid
		INTO	l_rid
		FROM	FLXT.IFTBS_HOFF_PARAM
		WHERE	branch_code	= '&&BRN'
		AND	external_system	= 'MUREX'
		AND	param_name	= 'VOSTRO_ACCOUNT_CLASS'
		AND	param_val	= '&&VAL';
		
		DELETE	FLXT.IFTBS_HOFF_PARAM
		WHERE	rowid = l_rid;
		
		DBMS_OUTPUT.put_line(TO_CHAR(SQL%ROWCOUNT)||' row deleted from IFTB_HOFF_PARAM');
		DBMS_OUTPUT.put_line('Pls issue command COMMIT; to commit the deletion Or ROLLBACK; to rollback');
		
	EXCEPTION
		WHEN NO_DATA_FOUND
		THEN
			DBMS_OUTPUT.put_line('Record does not exists, cannot delete');
	END;
EXCEPTION
	WHEN OTHERS
	THEN
		DBMS_OUTPUT.put_line('Err encountered '||SQLERRM);
END;
/
UNDEF VAL
UNDEF BRN
SET VERIFY ON
