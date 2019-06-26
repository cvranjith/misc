/*
CREATE VIEW cyvw_ccy_position_check (
   ac_branch,
   ac_ccy,
   contlcy,
   lcy,
   contfcy,
   fcy )
AS
(
SELECT
       AC_BRANCH
     , AC_CCY
     , SUM(DECODE(CATEGORY,'1',0,'2',0,'3',0,'4',0,'7',0, DECODE(DRCR_IND,
        'D',LCY_AMOUNT, -1*LCY_AMOUNT))) CONTLCY
     , SUM(DECODE(CATEGORY,'5',0,'6',0, '3', 0, '4', 0, DECODE(DRCR_IND,'D',
        LCY_AMOUNT, -1*LCY_AMOUNT))) LCY
     , SUM(DECODE(CATEGORY,'1',0,'2',0,'3',0,'4',0,'7',0, DECODE(DRCR_IND,
        'D',DECODE(AC_CCY,C.BRANCH_LCY,LCY_AMOUNT,FCY_AMOUNT),
         -1*DECODE(AC_CCY,C.BRANCH_LCY,LCY_AMOUNT,FCY_AMOUNT)))) CONTFCY
     , SUM(DECODE(CATEGORY,'5',0,'6',0,'3',0,'4',0, DECODE(DRCR_IND,'D',
        DECODE(AC_CCY,C.BRANCH_LCY,LCY_AMOUNT,FCY_AMOUNT),  -1*DECODE(AC_CCY,
        C.BRANCH_LCY,LCY_AMOUNT,FCY_AMOUNT)))) FCY
FROM ACTBS_HISTORY A, STTMS_BANK B,STTMS_BRANCH C
WHERE B.BANK_CODE = C.BANK_CODE AND C.BRANCH_CODE=A.AC_BRANCH
--AND NVL(DELETE_STAT,'X') <> 'D'
AND AC_CCY <> C.BRANCH_LCY
AND a.category NOT in ('8','9')
GROUP BY AC_BRANCH ,AC_CCY
UNION ALL
SELECT
       AC_BRANCH
     , C.BRANCH_LCY
     , SUM(DECODE(CATEGORY,'1',0,'2',0,'3',0,'4',0,'7',0, DECODE(DRCR_IND,
        'D',LCY_AMOUNT, -1*LCY_AMOUNT))) CONTLCY
     , SUM(DECODE(CATEGORY,'5',0,'6',0, DECODE(DRCR_IND,'D',
        LCY_AMOUNT, -1*LCY_AMOUNT))) LCY
     , 0 CONTFCY
     , 0 FCY
FROM ACTBS_HISTORY A, STTMS_BANK B,STTMS_BRANCH C
WHERE B.BANK_CODE = C.BANK_CODE AND C.BRANCH_CODE=A.AC_BRANCH
--AND NVL(DELETE_STAT,'X') <> 'D'
AND (AC_CCY = C.BRANCH_LCY OR CATEGORY IN ('3', '4'))
AND a.category NOT in ('8','9')
GROUP BY AC_BRANCH, C.BRANCH_LCY
)
*/



select * from CYTBS_CCY_POSITION
minus
select  ac_branch,
        ac_ccy,
        fcy,
        contfcy,
        lcy,
        contlcy
from cyvw_ccy_position_check
/

