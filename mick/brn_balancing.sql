col real_diff form 99999999.999
col cont_diff form 99999999.999
col memo_diff form 99999999.999
col pos_Diff form 99999999.999
col financial_cycle form a6
col period_code form a3
col module form a2
col batch_no form a4
col user_id form a10

undef brn
accept brn PROMPT 'Enter the brn code => '
SET LINE 150 numf 999999999999999999.9999 VERIFY OFF
PROMPT ===========================================
PROMPT Branch balancing means
PROMPT 			real_dr = real_cr
PROMPT 			cont_dr = cont_cr
PROMPT 			memo_dr = memo_cr
PROMPT 			pos_dr = pos_cr
PROMPT ===========================================
PROMPT
SELECT	SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0))) real_dr,
		SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0))) real_cr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0))) cont_dr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0))) cont_cr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0))) memo_dr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0))) memo_cr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'7',0,DECODE(drcr_ind,'D',lcy_amount,0))) pos_dr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'7',0,DECODE(drcr_ind,'C',lcy_amount,0))) pos_cr,
		financial_cycle,
		period_code
FROM ACTBS_DAILY_LOG
WHERE ac_branch=upper('&&brn')
AND balance_upd IN ('U','R') AND NVL(delete_stat,'X') <> 'D'
GROUP BY financial_cycle, period_code
/

select REAL_CR-REAL_DR REAL_DIFF, CONT_CR-CONT_DR CONT_DIFF, MEMO_CR-MEMO_DR MEMO_IDFF, POS_CR-POS_DR POS_DIFF, FINANCIAL_CYCLE, PERIOD_CODE
FROM
(
SELECT	SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0))) real_dr,
		SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0))) real_cr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0))) cont_dr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0))) cont_cr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0))) memo_dr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0))) memo_cr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'7',0,DECODE(drcr_ind,'D',lcy_amount,0))) pos_dr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'7',0,DECODE(drcr_ind,'C',lcy_amount,0))) pos_cr,
		financial_cycle,
		period_code
FROM ACTBS_DAILY_LOG
WHERE ac_branch=upper('&&brn')
AND balance_upd IN ('U','R') AND NVL(delete_stat,'X') <> 'D'
GROUP BY financial_cycle, period_code
)

/

select REAL_CR-REAL_DR REAL_DIFF, CONT_CR-CONT_DR CONT_DIFF, MEMO_CR-MEMO_DR MEMO_IDFF, POS_CR-POS_DR POS_DIFF, FINANCIAL_CYCLE, PERIOD_CODE,MODULE,BATCH_NO,user_id
FROM
(
SELECT	SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0))) real_dr,
		SUM(DECODE(category,'5',0,'6',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0))) real_cr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0))) cont_dr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'7',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0))) cont_cr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'8',0,'9',0,DECODE(drcr_ind,'D',lcy_amount,0))) memo_dr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'8',0,'9',0,DECODE(drcr_ind,'C',lcy_amount,0))) memo_cr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'7',0,DECODE(drcr_ind,'D',lcy_amount,0))) pos_dr,
		SUM(DECODE(category,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'7',0,DECODE(drcr_ind,'C',lcy_amount,0))) pos_cr,
		financial_cycle,
		period_code,MODULE,BATCH_NO,user_id
FROM ACTBS_DAILY_LOG
WHERE ac_branch=upper('&&brn')
AND balance_upd IN ('U','R') AND NVL(delete_stat,'X') <> 'D'
GROUP BY financial_cycle, period_code,MODULE,BATCH_NO,user_id
)
WHERE REAL_CR-REAL_DR != 0
OR CONT_CR-CONT_DR != 0
OR MEMO_CR-MEMO_DR != 0
OR POS_CR-POS_DR !=0
/

SET VERIFY ON

undef brn
