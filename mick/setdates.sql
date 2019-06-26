@storeset
@today

SET FEEDBACK OFF VERIFY OFF
DECLARE
	B VARCHAR2(3) :=upper(nvl( '&BRN','ALL'));
	T DATE := '&NEW_TODAY';
	N DATE;
	P DATE;
	E VARCHAR2(1000);
BEGIN
	IF T IS NOT NULL
	THEN
dbms_output.put_line('T '||t||':'||b);
for i in (select branch_code from sttm_branch where branch_code = decode(b,'ALL',branch_code,b)) loop
dbms_output.put_line('>>> '||i.branch_code);
		GLOBAL.PR_INIT(i.branch_code,'SYSTEM');
		N := cepkss_date.fn_getworkingday('LCL', i.branch_code,T,'N',1);
		P := cepkss_date.fn_getworkingday('LCL', i.branch_code,T,'P',1);
dbms_output.put_line('>>> '||n);
		UPDATE	STTMS_DATES
		SET	TODAY = T,
			NEXT_WORKING_DAY = N,
			PREV_WORKING_DAY = P
		WHERE	BRANCH_CODE = i.branch_code;
		DBMS_OUTPUT.PUT_LINE(TO_CHAR(SQL%ROWCOUNT)||' ROW UPDATED');
		DBMS_SESSION.RESET_PACKAGE;
		GLOBAL.PR_INIT(i.branch_code,'SYSTEM');
		WRP_BATCH.PR_AEODDATESET(E,i.branch_code,'SYSTEM','DATESET');
end loop;
	END IF;
END;
/
@restoreset
@today

