@storeset
@today

UNDEF BRN EOI

ACCEPT BRN CHAR PROMPT 'Enter Branch code  ==> '
PROMPT
PROMPT
PROMPT Transaction Input -- N
PROMPT EOTI              -- T
PROMPT EOFI              -- F
PROMPT EOD               -- E
PROMPT BOD               -- B
PROMPT 
ACCEPT EOI CHAR PROMPT 'Enter End Of Input ==> '

SET FEEDBACK OFF VERIFY OFF
DECLARE
	B VARCHAR2(3) := '&&BRN';
	E VARCHAR2(10) := '&&EOI';
BEGIN
	IF NVL(E,'X') IN ('N','T','F','E','B')
	THEN
		GLOBAL.PR_INIT(B,'SYSTEM');
		UPDATE	STTMS_BRANCH
		SET	END_OF_INPUT = E
		WHERE	BRANCH_CODE = B;
		DBMS_OUTPUT.PUT_LINE(TO_CHAR(SQL%ROWCOUNT)||' ROW UPDATED');
	END IF;
END;
/
@restoreset
@today


UNDEF BRN EOI
