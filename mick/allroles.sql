SET SERVEROUT ON SIZE 10000
BEGIN
FOR I IN (SELECT * FROM STTM_BRANCH) LOOP
BEGIN
INSERT INTO SMTB_USER_ROLE VALUES ('ALLROLES_UFJ','MAIN','A',I.BRANCH_CODE);
DBMS_OUTPUT.PUT_LINE('INSERTED MAIN '||I.BRANCH_CODE);
EXCEPTION
WHEN OTHERS
THEN
NULL;
END;

BEGIN
INSERT INTO SMTB_USER_ROLE VALUES ('ALLROLES_UFJ','DUMMY','A',I.BRANCH_CODE);
DBMS_OUTPUT.PUT_LINE('INSERTED DUMMY '||I.BRANCH_CODE);
EXCEPTION
WHEN OTHERS
THEN
NULL;
END;

END LOOP;
COMMIT;
END;
/

