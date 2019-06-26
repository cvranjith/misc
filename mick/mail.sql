@storeset

SET VERIFY OFF FEED OFF

DELETE
MSTB_AUTO_MAIL;

INSERT INTO MSTB_AUTO_MAIL
(NAME,ACTUAL_NAME,EMAIL_ID)
VALUES 
('SENDER','Flexcube Implementation Team','flexcube.eab@eab.com.vn')
/

INSERT INTO MSTB_AUTO_MAIL
(NAME,ACTUAL_NAME,EMAIL_ID)
SELECT
'ANTONY','ANTONY','antony.babu@iflexsolutions.com'
FROM DUAL WHERE UPPER('&ANTO') = 'Y'
/
INSERT INTO MSTB_AUTO_MAIL
(NAME,ACTUAL_NAME,EMAIL_ID)
SELECT
'RAJANI','RAJANI','rajani.kamath@iflexsolutions.com'
FROM DUAL WHERE UPPER('&RAJANI') = 'Y'
/

INSERT INTO MSTB_AUTO_MAIL
(NAME,ACTUAL_NAME,EMAIL_ID)
SELECT
'TUAN','TUAN','tuanta@eab.com.vn' FROM DUAL WHERE UPPER('&TUAN') = 'Y'
/

INSERT INTO MSTB_AUTO_MAIL
(NAME,ACTUAL_NAME,EMAIL_ID)
SELECT
'VUNH','VUNH','vunh@eab.com.vn' FROM DUAL WHERE UPPER('&VUNH') = 'Y'
/

INSERT INTO MSTB_AUTO_MAIL
(NAME,ACTUAL_NAME,EMAIL_ID)
SELECT
'HUNGTV','HUNGTV','hungtv@eab.com.vn' FROM DUAL WHERE UPPER('&HUNGTV') = 'Y'
/

INSERT INTO MSTB_AUTO_MAIL
(NAME,ACTUAL_NAME,EMAIL_ID)
VALUES 
('RANJITH','RANJITH','cv.ranjith@gmail.com')
/


EXEC MAILFROMDB1

ROLLBACK;

@restoreset
