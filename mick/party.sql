DECLARE
	L1	VARCHAR2(1000) := '/X/BCD';
	L2	VARCHAR2(1000) := 'CITINYUS';
	L3	VARCHAR2(1000);
	L4	VARCHAR2(1000);
	O	VARCHAR2(1000);
BEGIN
	IF NOT ispkss_party.validate_party
		(
		L1,
		L2,
		L3,
		L4,
		TRUE,
		TRUE,
		FALSE,
		TRUE,
		O
		)
	THEN
		DBMS_OUTPUT.PUT_LINE ('VALIDATION FAILED');
	END IF;
	DBMS_OUTPUT.PUT_LINE ('OPTION '||O);
END;
/
