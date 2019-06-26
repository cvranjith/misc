SET FEEDBACK OFF VERIFY OFF
DECLARE
	B VARCHAR2(3) := '140';
	N DATE;
	P DATE;
	E VARCHAR2(1000);
	D DATE;
	NN DATE;
BEGIN
	SELECT 	TODAY
	INTO	D
	FROM	STTM_DATES
	WHERE	BRANCH_CODE = B;
	N := cepkss_date.fn_getworkingday('LCL', B,D,'N',1);
	NN := cepkss_date.fn_getworkingday('LCL', B,N,'N',1);
	GLOBAL.PR_INIT(B,'SYSTEM');
	UPDATE	STTMS_DATES
	SET	TODAY = N,
		NEXT_WORKING_DAY = NN,
		PREV_WORKING_DAY = D
	WHERE	BRANCH_CODE = B;
	DBMS_OUTPUT.PUT_LINE(TO_CHAR(SQL%ROWCOUNT)||' ROW UPDATED');
	GLOBAL.PR_INIT(B,'SYSTEM');
	WRP_BATCH.PR_AEODDATESET(E,B,'SYSTEM','DATESET');
	
	UPDATE 	STTM_BRANCH
	SET	END_OF_INPUT = 'B'
	WHERE	BRANCH_CODE = B;
	WRP_BATCH.PR_AEODICEOD(E,B,'SYSTEM','ICEOD');

	DBMS_OUTPUT.PUT_LINE('FINISHED BOD '||N);
	COMMIT;
	
	UPDATE 	STTM_BRANCH
	SET	END_OF_INPUT = 'T'
	WHERE	BRANCH_CODE = B;

	GLOBAL.PR_INIT(B,'SYSTEM');
	WRP_BATCH.PR_AEODICEOD(E,B,'SYSTEM','ICEOD');

	DBMS_OUTPUT.PUT_LINE('FINISHED EOTI '||N);
	COMMIT;
END;
/
