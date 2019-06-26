SET SERVEROUT ON VERIFY OFF FEED OFF
DECLARE
	u			VARCHAR2(100) := UPPER('&USERID') ;
	functionid		VARCHAR2(100) := UPPER('&FUNCTN');
	p_txn_status		VARCHAR2(100) ;
	p_auth_status		VARCHAR2(100);
	p_int_status		VARCHAR2(100);
	final_control_string	SMTBS_ROLE_DETAIL.control_string%TYPE	:= '0000000000000000' ;
	temp_control_string	SMTBS_ROLE_DETAIL.control_string%TYPE	:= '0000000000000000' ;
	user_control_string	SMTBS_ROLE_DETAIL.control_string%TYPE	:= '0000000000000000' ;
	func_control_string	SMTBS_ROLE_DETAIL.control_string%TYPE	:= '0000000000000000' ;
	tran_control_string	SMTBS_ROLE_DETAIL.control_string%TYPE	:= '1111111111111111' ;
	inter_control_string	SMTBS_ROLE_DETAIL.control_string%TYPE;
	b 			VARCHAR2(1000) := '&BRANCH';
	CURSOR	func_cursor
	IS	SELECT	role_id,
			role_function,
			control_string
		FROM	SMTBS_ROLE_DETAIL
		WHERE	role_id IN 
				(
				SELECT	role_id
				FROM	SMTBS_USER_ROLE
				WHERE	user_id = u
				and	branch_code = b
				)
		AND	role_function = functionid;

	FUNCTION	f
			(
			ctl_string1	VARCHAR2,
			ctl_string2	VARCHAR2
			)
	RETURN VARCHAR2
	IS
		ctl_return	VARCHAR2(16);
		ctl1		CHAR(1);
		ctl2		CHAR(1);
	BEGIN
		FOR i IN 1..16
		LOOP
			ctl1 := (substr(ctl_string1,i,1));
			ctl2 := (substr(ctl_string2,i,1));
			IF ctl1 = '0' AND ctl2 = '0'
			THEN
				ctl_return := ctl_return || '0';
			ELSE
				ctl_return := ctl_return || '1';
 			END IF;
		END LOOP;
		RETURN ctl_return ;
	END;

BEGIN
	
	BEGIN
		SELECT	controL_string
		INTO	user_control_string
		FROM	SMTBS_USERS_FUNCTIONS
		WHERE	user_id = u
		AND	function_id = functionid
		AND	branch_code=b;
	EXCEPTION
		WHEN NO_DATA_FOUND
		THEN
			DBMS_OUTPUT.PUT_LINE('FUNC_CUR');
			FOR something IN func_cursor
			LOOP
				EXIT WHEN func_cursor%NOTFOUND;
				DBMS_OUTPUT.PUT_LINE('SOMETHING '||something.ROLE_ID||' '||something.control_string);
				inter_control_string	:= something.control_string;
				user_control_string	:= f(user_control_string , inter_control_string);
				DBMS_OUTPUT.PUT_LINE('SOMETHING= '||user_control_string);
			END LOOP;
	END;
	
	BEGIN
		SELECT	control_string
		INTO	tran_control_string
		FROM	SMTBS_TXN_STATUS
		WHERE	txn_status = p_txn_status
		AND 	auth_status = p_auth_status
		AND 	interface_status = nvl(p_int_status,'XXXXX') ;
	EXCEPTION
		WHEN NO_DATA_FOUND
		THEN
			tran_controL_string := '1111111111111111';
	END;
	
	BEGIN
		SELECT	control_string
		INTO	func_control_string
		FROM	SMTBS_MENU
		WHERE	function_id = functionid;
	EXCEPTION
		WHEN NO_DATA_FOUND
		THEN
			NULL;
	END;
	
	user_control_string := lpad(user_control_string,16,'0');
	tran_control_string := lpad(tran_control_string,16,'0');
	func_control_string := lpad(func_control_string,16,'0');
	temp_control_string := to_char(	to_number(user_control_string) + to_number(tran_control_string) + to_number(func_control_string));
	
	SELECT	TRANSLATE(temp_control_string,'3210','1000')
	INTO	final_control_string
	FROM	dual;
	
	DBMS_OUTPUT.put_line(' *');
	DBMS_OUTPUT.put_line(' ********************************');
	DBMS_OUTPUT.put_line(' *');
	DBMS_OUTPUT.put_line(' ===USER==== '||user_control_string);
	DBMS_OUTPUT.put_line(' ===TRAN==== '||tran_control_string);
	DBMS_OUTPUT.put_line(' ===FUNC==== '||func_control_string);
	DBMS_OUTPUT.put_line(' *');
	DBMS_OUTPUT.put_line(' ********************************');
	DBMS_OUTPUT.put_line(' *');
	DBMS_OUTPUT.put_line(' ***FINAL*** '||final_control_string);
end;
/

SET VERIFY ON FEED ON
PROMPT
PROMPT
