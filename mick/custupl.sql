DECLARE
E VARCHAR2(1000);
P VARCHAR2(1000);
CURSOR C
IS
	SELECT	CUSTOMER_NO
	FROM 	STTM_UPLOAD_CUSTOMER;
BEGIN
	GLOBAL.PR_INIT('100','SYSTEM');
	IF NOT stpks_cust_upload.fn_stupload('UPL007',E,P) THEN
		DBMS_OUTPUT.PUT_LINE('####################### '||E||' ## '||P);
	END IF;
	FOR X IN C
	LOOP
		BEGIN
			INSERT INTO MITM_CUSTOMER_DEFAULT
				(
				customer,
				comp_mis_1
				)
			VALUES
				(
				x.customer_no,
				'9433'
				);
		EXCEPTION
			WHEN OTHERS
			THEN
				DBMS_OUTPUT.put_line(' E '||SQLERRM);
		END;
	END LOOP;
END;
/
