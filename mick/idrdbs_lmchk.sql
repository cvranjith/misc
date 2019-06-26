SET LINE 9999 NUMF 999999999999999999999999999.9999 TRIMSPOOL ON SERVEROUT ON SIZE 1000000 FEED OFF PAGES 0 

/*
FUNCTION FN_LIMIT_ccyamt1_to_amt2(brn VARCHAR2,ccy1 VARCHAR2, ccy2 VARCHAR2, amt1 NUMBER)
RETURN NUMBER IS
 amt2 NUMBER; 
BEGIN
 IF ccy1 = ccy2 
 THEN 
  RETURN amt1;
 END IF;
 IF NVL(GLOBAL.current_branch,'!~#') <> brn
 THEN
  GLOBAL.pr_init(brn,'SYSTEM');
 END IF;
 lmpks_misc.ccyamt1_to_amt2(brn ,ccy1 ,ccy2 ,amt1 ,amt2);
 RETURN amt2;
EXCEPTION
WHEN OTHERS
 THEN
  RETURN NULL;
END;
*/

SPO TMP.TMP
SELECT	'SPO D:\IFLEX\GENERAL\LM_MISMATCH_'||TO_CHAR(SYSDATE,'DDMONYYYY.HH24MISS')||'.SPL' FROM	DUAL;
SPO OFF
SET FEED ON PAGES 100 
@TMP.TMP



PROMPT MISMATCH IN LC

SELECT * FROM
(
select	CONTRACT_REF_NO,
	CONTRACT_AMT,
	CREDIT_LINE,
	LINE_PARTY_TYPE,
	LINE_CIF_ID,
	DECODE
	(
		(select contract_status from cstb_contract where contract_ref_no = a.CONTRACT_rEF_NO),'H',0,'V',0,'S',0,'K',0,
		(SELECT OS_LIABILITY FROM LCTB_AVAILMENTS WHERE CONTRACT_REF_NO = A.CONTRACT_REF_NO
		AND EVENT_SEQ_NO = (SELECT MAX(EVENT_SEQ_NO) FROM LCTB_AVAILMENTS WHERE CONTRACT_REF_NO = A.CONTRACT_REF_NO))
	)OS_LIAB,
	(SELECT LIAB_ID FROM LMTB_LINE_UTILS WHERE REF_NO = A.CONTRACT_rEF_NO) LIAB,
	(SELECT nvl(AMT,0) - nvl(matured_amt,0) FROM LMTB_LINE_UTILS WHERE REF_NO = A.CONTRACT_rEF_NO ) UTIL,
	(select contract_status from cstb_contract where contract_ref_no = a.CONTRACT_rEF_NO) CONTRACT_STATUS
from	lctb_CONTRACT_MASTER A
WHERE 	CREDIT_LINE IS NOT NULL
AND 	EVENT_SEQ_NO = (SELECT MAX(EVENT_SEQ_NO) FROM LCTB_CONTRACT_MASTER WHERE CONTRACT_rEF_NO = A.CONTRACT_REF_NO)
)
WHERE UTIL <> OS_LIAB

/



PROMPT MISMATCH IN BILLS

SELECT * FROM
(
SELECT	BCREFNO,
	PARTY_TYPE,
	LINE ,
	(SELECT PARTY_ID FROM BCTB_CONTRACT_PARTIES P WHERE P.PARTY_TYPE = A.PARTY_TYPE
	AND P.BCREFNO = A.BCREFNO
	AND P.EVENT_SEQ_NO = (SELECT MAX(I.EVENT_SEQ_NO) FROM 
	BCTB_CONTRACT_PARTIES I WHERE I.PARTY_TYPE = A.PARTY_TYPE
	AND I.BCREFNO = A.BCREFNO)
	) PARTY_ID,
	(SELECT LIAB_ID FROM LMTB_LINE_UTILS WHERE REF_NO = A.BCREFNO AND AMT_TAG = 'PRINCIPAL'
     and liab_id = 	(SELECT PARTY_ID FROM BCTB_CONTRACT_PARTIES P WHERE P.PARTY_TYPE = A.PARTY_TYPE
	AND P.BCREFNO = A.BCREFNO
	AND P.EVENT_SEQ_NO = (SELECT MAX(I.EVENT_SEQ_NO) FROM 
	BCTB_CONTRACT_PARTIES I WHERE I.PARTY_TYPE = A.PARTY_TYPE
	AND I.BCREFNO = A.BCREFNO)
    )) LIAB,
	NVL((SELECT SUM(nvl(AMT,0) - nvl(matured_amt,0)) FROM LMTB_LINE_UTILS WHERE REF_NO = A.BCREFNO
     AND AMT_TAG = 'PRINCIPAL'
     and liab_id = 	(SELECT PARTY_ID FROM BCTB_CONTRACT_PARTIES P WHERE P.PARTY_TYPE = A.PARTY_TYPE
	 AND P.BCREFNO = A.BCREFNO
	 AND P.EVENT_SEQ_NO = (SELECT MAX(I.EVENT_SEQ_NO) FROM 
	 BCTB_CONTRACT_PARTIES I WHERE I.PARTY_TYPE = A.PARTY_TYPE
	 AND I.BCREFNO = A.BCREFNO)
    )
    ),0) UTIL,
	DECODE (
	(SELECT STAGE FROM BCTB_CONTRACT_MASTER B WHERE B.BCREFNO = A.BCREFNO AND B.EVENT_SEQ_NO=
	(SELECT MAX(EVENT_SEQ_NO) FROM BCTB_CONTRACT_MASTER C WHERE C.BCREFNO = B.BCREFNO )
	),'INI',0,
	(DECODE(
	(select contract_status from cstb_contract where contract_ref_no = a.bcrefno),'V',0,'S',0,'L',0,'H',0,
	(SELECT BILL_DUE_AMT FROM BCTB_CONTRACT_MASTER B WHERE B.BCREFNO = A.BCREFNO AND B.EVENT_SEQ_NO=
	(SELECT MAX(EVENT_SEQ_NO) FROM BCTB_CONTRACT_MASTER C WHERE C.BCREFNO = B.BCREFNO )
	)
	)
	)
	)
	 BILL_DUE_AMT,
	(SELECT STAGE FROM BCTB_CONTRACT_MASTER B WHERE B.BCREFNO = A.BCREFNO AND B.EVENT_SEQ_NO=
		(SELECT MAX(EVENT_SEQ_NO) FROM BCTB_CONTRACT_MASTER C WHERE C.BCREFNO = B.BCREFNO )
	) STAGE,
	(select contract_status from cstb_contract where contract_ref_no = a.bcrefno) CONTRACT_STATUS
FROM BCTB_CONTRACT_LIMITS A
WHERE 	EVENT_SEQ_NO = (SELECT MAX(EVENT_SEQ_NO) FROM BCTB_CONTRACT_MASTER L
	WHERE L.BCREFNO = A.BCREFNO)
)
WHERE nvl(BILL_DUE_AMT,0) <> nvl(UTIL,0)
/

PROMPT MISMATCH IN LD/MM

SELECT * FROM
(
SELECT	CONTRACT_REF_NO,
	CREDIT_LINE,
	AMOUNT,
	(NVL((SELECT PRINCIPAL_OUTSTANDING_BAL FROM LDTB_CONTRACT_BALANCE WHERE CONTRACT_REF_NO = A.CONTRACT_REF_NO),0)) OUTSTANDING_BAL,
	(SELECT LIAB_ID FROM LMTB_LINE_UTILS WHERE REF_NO = A.CONTRACT_rEF_NO) LIAB,
	(nvl((SELECT nvl(AMT,0) - nvl(matured_amt,0) FROM LMTB_LINE_UTILS WHERE REF_NO = A.CONTRACT_rEF_NO ),0)) UTIL,
	(select contract_status from cstb_contract where contract_ref_no = a.CONTRACT_rEF_NO) CONTRACT_STATUS,
	(SELECT trim(LINE_ID) FROM LMTB_LINE_UTILS WHERE REF_NO = A.CONTRACT_rEF_NO) UTL_LINE
FROM 	LDTB_CONTRACT_MASTER A
WHERE	A.VERSION_NO = (SELECT MAX(VERSION_NO) FROM LDTB_cONTRACT_MASTER B WHERE B.CONTRACT_REF_NO = A.CONTRACT_REF_NO)
AND 	CREDIT_LINE IS NOT NULL
)
WHERE (UTIL <> OUTSTANDING_BAL) OR (UTL_LINE != credit_line)
/

PROMPT MISMATCH IN FX

SELECT * FROM
(
SELECT  A.CONTRACT_REF_NO,
 A.COUNTERPARTY,
 A.BOT_AMOUNT,
 A.BOT_CCY,
 A.CREDIT_LINE,
 (SELECT CONTRACT_STATUS FROM CSTB_CONTRACT WHERE CONTRACT_REF_NO = A.CONTRACT_REF_NO) STAT,
 (SELECT LIAB_ID FROM LMTB_LINE_UTILS WHERE REF_NO = A.CONTRACT_rEF_NO) LIAB,
 (SELECT CCY FROM LMTB_LINE_UTILS WHERE REF_NO = A.CONTRACT_rEF_NO) CCY,
 (SELECT nvl(AMT,0) - nvl(matured_amt,0) FROM LMTB_LINE_UTILS WHERE REF_NO = A.CONTRACT_rEF_NO ) UTIL,
 (DECODE(
 (SELECT CONTRACT_STATUS FROM CSTB_CONTRACT WHERE CONTRACT_REF_NO = A.CONTRACT_REF_NO),'L',0,'V',0,'K',0,'H',0,
 BOT_AMOUNT
 )) BOT_AMT_UTIL
FROM  FXTB_CONTRACT_MASTER A
WHERE RPAD(TO_CHAR(VERSION_NO),16,'0') ||RPAD(TO_CHAR(EVENT_SEQ_NO),16,'0') =
 (SELECT MAX(RPAD(TO_CHAR(VERSION_NO),16,'0') ||RPAD(TO_CHAR(EVENT_SEQ_NO),16,'0'))
 FROM  FXTB_CONTRACT_MASTER B WHERE A.CONTRACT_rEF_NO = B.CONTRACT_REF_NO)
)
WHERE NVL(BOT_AMT_UTIL,0) <> NVL(UTIL,0)
/

PROMPT MISMATCH IN SUB-LINE UTILISATIONS

SELECT * FROM
(
select	A.*,
	(
		select SUM(NVL(LINE_CCY_UTIL,0) - DECODE(A.REVOLVING_LINE,'N',0,NVL(LINE_CCY_MAT,0))) 
		from LMTB_LINE_UTILS 
		where liab_id = a.liab_id
		and 
		(
		(ltrim(rtrim(line_id)) = ltrim(rtrim(a.line_cd))||ltrim(rtrim(to_char(a.line_serial))))
		)
	) SUM_UTIL
from	lmtmS_limits a
where EXISTS
( SELECT 'A'
  FROM	 LMTB_LINE_UTILS U
  WHERE	 U.LINE_CD = A.LINE_CD
  AND	 U.LIAB_ID = A.LIAB_ID
  AND	 U.LINE_SERIAL = A.LINE_SERIAL
)	
AND 	RECORD_STAT = 'O'
--AND		(AMOUNT_UTILISED_TODAY <> 0 OR AMOUNT_REINSTATED_TODAY <> 0)
)
WHERE SUM_UTIL <> UTILISATION
/

PROMPT MISMATCH IN MAIN-LINE UTILISATIONS

SELECT * FROM
(
SELECT MLUTIL.*,
	   (
	   SELECT UTILISATION
	   FROM   LMTM_LIMITS M
	   WHERE  LTRIM(RTRIM(M.LINE_CD))||LTRIM(RTRIM(TO_CHAR(M.LINE_SERIAL))) = MLUTIL.MAIN_LINE
	   AND 	  M.LIAB_ID = MLUTIL.LIAB_ID
	   ) LINE_UTIL,
	   (
	   SELECT RECORD_STAT
	   FROM   LMTM_LIMITS M
	   WHERE  LTRIM(RTRIM(M.LINE_CD))||LTRIM(RTRIM(TO_CHAR(M.LINE_SERIAL))) = MLUTIL.MAIN_LINE
	   AND 	  M.LIAB_ID = MLUTIL.LIAB_ID
	   ) RECORD_STAT
FROM
(
SELECT	SUM(ML_UTIL) ML_UTIL,
	MAIN_LINE,
	LIAB_ID
FROM
	(
	SELECT	LIAB_ID,LINE_CD,
		LINE_SERIAL,UTILISATION,
		FN_LIMIT_ccyamt1_to_amt2
			(
			LIAB_BR,
			LINE_CURRENCY,
				(
				SELECT	LINE_CURRENCY
				FROM	LMTM_LIMITS ML
				WHERE	ML.LIAB_ID = SL.LIAB_ID
				AND	LTRIM(RTRIM(ML.LINE_CD))||LTRIM(RTRIM(TO_CHAR(ML.LINE_SERIAL))) = LTRIM(RTRIM(SL.MAIN_LINE))
				),
			UTILISATION
		) ML_UTIL,
		MAIN_LINE
	FROM	LMTM_LIMITS SL
	WHERE	MAIN_LINE IS NOT NULL
	)
	GROUP BY MAIN_LINE,LIAB_ID
) MLUTIL
)
WHERE ML_UTIL <> LINE_UTIL
AND RECORD_STAT = 'O'
/


PROMPT MISMATCH IN LMTM_LIAB

select 	LIAB_BR,
	liab_id,
	RECORD_STAT,
	LIMIT_CCY,
	util_amt,
	(select sum(liab_util) from lmtb_line_utils where liab_id = a.liab_id AND track_cust_exp='Y') SUM_UTIL
from 	lmtm_liab a
where 	util_amt
	<> 
	(select sum(liab_util) from lmtb_line_utils where liab_id = a.liab_id AND track_cust_exp='Y') 
/

PROMPT ACCOUNTS 

-- NEED TO RERUN AFTER AUTHORIZING ALL TRNS

SELECT * FROM
(SELECT CUST_AC_NO, CUST_NO, CCY, ACY_AVL_BAL,
	   (
	   SELECT (nvl(AMT,0) - nvl(matured_amt,0))
	   FROM LMTB_LINE_UTILS
	   WHERE IS_ACCOUNT ='Y'
	   AND REF_NO = A.CUST_AC_NO
	   AND AMT_TAG = 'BALANCE') UTL,
	   (
	   SELECT LINE_ID||'~'||LINE_CCY 
	   FROM LMTB_LINE_UTILS
	   WHERE IS_ACCOUNT ='Y'
	   AND REF_NO = A.CUST_AC_NO
	   AND AMT_TAG = 'BALANCE') LINE_CCY_ID,
	   ACY_UNAUTH_DR,          
	   ACY_UNAUTH_CR     
FROM   STTM_CUST_ACCOUNT A
WHERE	ACY_AVL_BAL < 0
)
WHERE -ACY_AVL_BAL <> UTL
AND SUBSTR(NVL(LINE_CCY_ID,'*'),1,9) <> 'DUMMYLINE'
/


PROMPT REVOLVING LINES ATTACHED TO NON-REVOLVING MAIN LINES;

SELECT	*
FROM 	LMTM_LIMITS A
WHERE	RECORD_STAT = 'O'
AND	REVOLVING_LINE = 'Y'
AND	LTRIM(RTRIM(MAIN_LINE)) IN
	(
	SELECT LTRIM(RTRIM(LINE_CD))|| LTRIM(RTRIM(TO_CHAR(LINE_SERIAL))) FROM LMTM_LIMITS B
	WHERE REVOLVING_LINE = 'N'
	AND A.LIAB_ID = B.LIAB_ID
	)
/


PROMPT NON-REVOLVING LINES ATTACHED REVOLVING TO MAIN LINES;

SELECT	*
FROM 	LMTM_LIMITS A
WHERE 	RECORD_STAT = 'O'
AND 	REVOLVING_LINE = 'N'
AND 	LTRIM(RTRIM(MAIN_LINE)) IN
	(
	SELECT LTRIM(RTRIM(LINE_CD))|| LTRIM(RTRIM(TO_CHAR(LINE_SERIAL))) FROM LMTM_LIMITS B
	WHERE REVOLVING_LINE = 'Y'
	AND A.LIAB_ID = B.LIAB_ID
	)
/


PROMPT LINES ATTACHED CLOSED MAIN LINES;

SELECT	*
FROM 	LMTM_LIMITS A
WHERE 	RECORD_STAT = 'O'
AND 	LTRIM(RTRIM(MAIN_LINE)) IN
	(
	SELECT	LTRIM(RTRIM(LINE_CD))|| LTRIM(RTRIM(TO_CHAR(LINE_SERIAL))) FROM LMTM_LIMITS B
	WHERE 	RECORD_STAT = 'C'
	AND	A.LIAB_ID = B.LIAB_ID
	)
/

PROMPT MISMATCH IN LINE CURRENCIES.

SELECT  A.LINE_CCY, B.LINE_CURRENCY, A.LIAB_ID, A.REF_NO, A.CCY, A.AMT, A.MATURED_AMT,
	A.LINE_ID, A.LINE_CCY_UTIL, A.LINE_CCY_MAT,
	A.LIAB_CCY, A.LIAB_UTIL, A.MAIN_LINE, A.MAIN_LINE_CCY, A.ML_UTIL
FROM 	LMTB_LINE_UTILS A,
	LMTM_LIMITS B
WHERE	LTRIM(RTRIM(A.LINE_ID)) = LTRIM(RTRIM(B.LINE_CD))||LTRIM(RTRIM(TO_CHAR(B.LINE_SERIAL)))
AND	A.LIAB_ID = B.LIAB_ID
AND	A.LINE_CCY <> B.LINE_CURRENCY
/

PROMPT MISMATCH IN MAIN LINE CURRENCIES.


SELECT  A.MAIN_LINE_CCY , B.LINE_CURRENCY,A.LIAB_ID, A.REF_NO, A.CCY, A.AMT, A.MATURED_AMT,
	A.LINE_ID, A.LINE_CCY, A.LINE_CCY_UTIL, A.LINE_CCY_MAT,
	A.LIAB_CCY, A.LIAB_UTIL, A.MAIN_LINE, A.ML_UTIL
FROM 	LMTB_LINE_UTILS A,
	LMTM_LIMITS B
WHERE	LTRIM(RTRIM(A.MAIN_LINE)) = LTRIM(RTRIM(B.LINE_CD))||LTRIM(RTRIM(TO_CHAR(B.LINE_SERIAL)))
AND	A.LIAB_ID = B.LIAB_ID
AND	A.MAIN_LINE_CCY <> B.LINE_CURRENCY
/

PROMPT MISMATCH IN LIAB CURRENCIES.

SELECT  A.LIAB_CCY , B.LIMIT_CCY,A.LIAB_ID, A.REF_NO, A.CCY, A.AMT, A.MATURED_AMT,
	A.LINE_ID, A.LINE_CCY, A.LINE_CCY_UTIL, A.LINE_CCY_MAT,
	A.LIAB_UTIL, A.MAIN_LINE, A.MAIN_LINE_CCY, A.ML_UTIL
FROM 	LMTB_LINE_UTILS A,
	LMTM_LIAB B
WHERE	A.LIAB_ID = B.LIAB_ID
AND	A.LIAB_CCY <> B.LIMIT_CCY
/


PROMPT MISMATCH IN MAIN LINE ID

SELECT  A.MAIN_LINE, B.MAIN_LINE, A.LIAB_ID, A.REF_NO, A.CCY, A.AMT, A.MATURED_AMT,
	A.LINE_ID, A.LINE_CCY, A.LINE_CCY_UTIL, A.LINE_CCY_MAT,
	A.LIAB_CCY, A.LIAB_UTIL, A.MAIN_LINE, A.ML_UTIL
FROM 	LMTB_LINE_UTILS A,
	LMTM_LIMITS B
WHERE	LTRIM(RTRIM(A.LINE_ID)) = LTRIM(RTRIM(B.LINE_CD))||LTRIM(RTRIM(TO_CHAR(B.LINE_SERIAL)))
AND	A.LIAB_ID = B.LIAB_ID
AND	LTRIM(RTRIM(A.MAIN_LINE)) <> LTRIM(RTRIM(B.MAIN_LINE))
/

/*
PROMPT TENOR MISMATCH

SELECT * FROM
(
SELECT LINE_CD, LINE_SERIAL, LIAB_ID, UTILISATION,
	   (
	   SELECT	SUM(LINE_CCY_UTIL)
	   FROM		LMTB_LINE_UTILS U
	   WHERE	U.LIAB_ID = A.LIAB_ID
	   AND	  U.LINE_SERIAL = A.LINE_SERIAL
	   AND	  U.LINE_CD = A.LINE_CD
	   ) SUM_LINE_UTIL,
	   (
	   SELECT SUM(B.UTILISATION)
	   FROM	  lmtms_limits_tenor_rest B
	   WHERE  A.LINE_CD = B.LINE_CD
	   AND	  A.LINE_SERIAL = B.LINE_SERIAL
	   AND	  A.LIAB_ID = B.LIAB_ID
	   ) TENOR_UTIL
FROM   LMTM_LIMITS A
WHERE  RECORD_STAT = 'O'
AND REVOLVING_LINE = 'Y'
and LTRIM(RTRIM(line_cd))||LTRIM(RTRIM(TO_CHAR(LINE_SERIAL)))
NOT in (select main_line from lmtm_limits c where c.liab_id = a.liab_id and main_line is not null)
) Q
WHERE SUM_LINE_UTIL <> TENOR_UTIL
/

*/

PROMPT LINE CCY DIFFERENT FROM MAIN LINE CCY

SELECT * FROM
(
SELECT A.LINE_CD, A.LINE_SERIAL, A.LIAB_ID, A.MAIN_LINE, A.LINE_CURRENCY LINE_CCY,
	   (
	   SELECT LINE_CURRENCY 
	   FROM LMTM_LIMITS B 
	   WHERE LTRIM(RTRIM(B.LINE_CD))||TO_CHAR(B.LINE_SERIAL) = LTRIM(RTRIM(A.MAIN_LINE))
	   AND A.LIAB_ID = B.LIAB_ID
	   ) MAIN_LINE_CCY
FROM LMTM_LIMITS A
WHERE RECORD_STAT = 'O'
AND MAIN_LINE IS NOT NULL
)
WHERE LINE_CCY <> MAIN_LINE_CCY
/


SPO OFF
