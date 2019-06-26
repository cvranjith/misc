UNDEF BRANCH
SET TRIMSPOOL ON PAGES 0 LINE 9999 FEED OFF VERIFY OFF

SPO TMP.TMP
SELECT 'DROP TABLE SEQ_TMP_CVR_X_Y_1_2;'
FROM USER_TABLES WHERE TABLE_NAME = 'SEQ_TMP_CVR_X_Y_1_2';
SPO OFF
@TMP.TMP

CREATE TABLE SEQ_TMP_CVR_X_Y_1_2
AS SELECT SEQUENCE_NAME FROM USER_SEQUENCES
WHERE SUBSTR(SEQUENCE_NAME,1,4) ='TRSQ'
AND SUBSTR(SEQUENCE_NAME,6,3) IN ('000','&&BRANCH');


SPO TMP.TMP

SELECT 'CREATE SEQUENCE TRSQ_&&BRANCH'||SUBSTR(SEQUENCE_NAME,9)||';'
FROM SEQ_TMP_CVR_X_Y_1_2 A
WHERE SUBSTR(SEQUENCE_NAME,1,8) = 'TRSQ_000'
AND NOT EXISTS
(
SELECT 1 FROM 
SEQ_TMP_CVR_X_Y_1_2 B
WHERE SUBSTR(B.SEQUENCE_NAME,1,8) = 'TRSQ_&&BRANCH'
AND SUBSTR(B.SEQUENCE_NAME,9) = SUBSTR(A.SEQUENCE_NAME,9)
)
/

SPO OFF

SET FEED ON PAGES 100

@TMP.TMP

SET FEED OFF
DROP TABLE SEQ_TMP_CVR_X_Y_1_2;
SET FEED ON
