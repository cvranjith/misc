SET VERIFY OFF
DECLARE
B VARCHAR2(3) := '&BRN';
U VARCHAR2(100) := '&USER';
BEGIN
DELETE CSTB_DEBUG_USERS WHERE USER_ID = u;
INSERT INTO CSTB_DEBUG_USERS (USER_ID,MODULE,DEBUG)
SELECT U,MODULE,'Y' FROM CSTB_DEBUG;
GLOBAL.PR_INIT(B,U);
DEBUG.pr_close;
DEBUG.PR_DEBUG('FT','Start');
delete  CSTB_DEBUG_USERS WHERE USER_ID = u;
END;
/
SET VERIFY ON
SELECT GLOBAL.WORK_AREA FROM DUAL;
