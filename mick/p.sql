alter session set current_schema=FLXT;

SELECT 
   	 	a.CONTRACT_REF_NO,
		a.BRANCH_CODE BRANCH,
        a.product_code, ---
		'CNY' CR_CCY,
		A.CUST_AC_CCY DR_CCY, 
		TXN_AMOUNT CR_AMOUNT,
	    FCY_AMOUNT DR_AMOUNT,
		SUBSTR( UDF_2,1, INSTR(UDF_2, ' -', 1, 1))  CODE,  
       A.cust_ac_no  "Account No", --
       A.EXCH_RATE "EXCHANGE_RATE", --
       F.TXN_MIS_1 "DB Product", --
       A.CUST_NO "CIF Number", --
			 SUBSTR( UDF_2,  INSTR(UDF_2, ' -', 1, 1)+2, LENGTH(UDF_2)) DESCRIPTION,
			 INITIATION_DT BOOKING_DT,
             Bo_Amt1_To_Amt2_Usd( a.BRANCH_CODE, A.CUST_AC_CCY, A.TXN_AMOUNT ) USD_AMOUNT
FROM
	pctb_contract_master  A,
	STTM_DATES D ,
   MITM_PRODUCT_DEFAULT f
WHERE a.BRANCH_CODE=D.BRANCH_CODE
AND CUST_AC_CCY <>'CNY'
AND PRODUCT_TYPE ='O'
AND F.product_code= A.PRODUCT_CODE
AND to_Date(to_char(INITIATION_DT,'DD/MM/RRRR'),'DD/MM/RRRR') BETWEEN TRUNC(TODAY) AND TODAY
 and a.Auth_status='A' and a.contract_status='L'
UNION
SELECT 
	   	a.CONTRACT_REF_NO,
      SUBSTR(A.CONTRACT_REF_NO,1,3) BRANCH,
      a.PRODUCT_CODE,--
			a.CR_CCY,
			a.DR_CCY, 
			A.CR_AMOUNT, 
			A.DR_AMOUNT,
			B.FIELD_VAL_2 CODE,  
      DR_ACCOUNT "Account No", --
			EXCHANGE_RATE, --
			F.TXN_MIS_1 "DB Product", --
			nvl(G.cust_no,H.walkin_customer)  "CIF Number", --
			(SELECT   LOV_DESC FROM UDTM_LOV WHERE FIELD_NAME	 ='TRANSACTION CODE' AND    LOV	=B.FIELD_VAL_2  ) DESCRIPTION,
			 ACCOUNTING_DATE,
      Bo_Amt1_To_Amt2_Usd( SUBSTR(A.CONTRACT_REF_NO,1,3), A.DR_CCY, A.DR_AMOUNT ) USD_AMOUNT
FROM
	FTTB_CONTRACT_MASTER  A,
	CSTM_CONTRACT_USERDEF_FIELDS B,
	STTM_DATES D,
	 FTTM_PRODUCT_DEFINITION e,
   MITM_PRODUCT_DEFAULT f,
  STTM_CUST_ACCOUNT G, 
  STTM_BRANCH H
WHERE a.product_code= e.product_code
AND e.PRODUCT_TYPE IN('O','N')
AND A.CONTRACT_REF_NO=B.CONTRACT_REF_NO(+)
AND ((DR_CCY='CNY' AND CR_CCY<>'CNY') OR (DR_CCY<>'CNY' AND CR_CCY='CNY'))
AND ACCOUNTING_DATE BETWEEN TRUNC(TODAY) AND TODAY
AND A.EVENT_SEQ_NO = (select max(EVENT_SEQ_NO) from fttb_contract_master L
                      where L.contract_ref_no=A.contract_ref_no)
AND SUBSTR(A.CONTRACT_REF_NO,1,3)=D.BRANCH_CODE
AND E.product_code=f.product_code
AND A.DR_ACCOUNT= G.cust_ac_no(+)
AND SUBSTR(A.CONTRACT_REF_NO,1,3)=G.BRANCH_CODE
AND SUBSTR(A.CONTRACT_REF_NO,1,3)=H.BRANCH_CODE
UNION
SELECT 	 A.TRN_REF_NO,
      TXN_BRANCH BRANCH,
      A.PRODUCT_CODE, --
			decode(DR_ACC,'OFS',TXN_CCY,OFS_CCY) CR_CCY,
			decode(DR_ACC,'TXN',TXN_CCY,OFS_CCY) DR_CCY, 
			decode(DR_ACC,'TXN',OFS_AMOUNT,TXN_AMOUNT) CR_AMOUNT,
			decode(DR_ACC,'TXN',TXN_AMOUNT,OFS_AMOUNT) DR_AMOUNT,
			B.FIELD_VAL_2 CODE,  
      DECODE(A.DR_ACC,'OFS',OFS_ACC,TXN_ACC) "Account No",-- Only one field so reporting debit account 
      A.EXCH_RATE "EXCHANGE_RATE", --
      E.TXN_MIS_1 "DB Product", --
      NVL(F.CUST_AC_NO,G.WALKIN_CUSTOMER) "CIF Number", --
			(SELECT   LOV_DESC FROM UDTM_LOV WHERE FIELD_NAME	 ='TRANSACTION CODE' AND    LOV	=B.FIELD_VAL_2  ) DESCRIPTION,
			TRN_DT ACCOUNTING_DATE,
            Bo_Amt1_To_Amt2_Usd(TXN_BRANCH, decode(DR_ACC,'TXN',TXN_CCY,OFS_CCY), decode(DR_ACC,'TXN',TXN_AMOUNT,OFS_AMOUNT)) USD_AMOUNT
FROM
	DETB_RTL_TELLER  A,
	CSTM_CONTRACT_USERDEF_FIELDS B,
	STTM_DATES D,
	 MITM_PRODUCT_DEFAULT E,
   STTM_CUST_ACCOUNT F,
   STTM_BRANCH G
WHERE TRN_DT BETWEEN TRUNC(TODAY) AND TODAY
AND ((TXN_CCY<>'CNY' AND OFS_CCY='CNY') OR (OFS_CCY<>'CNY' AND TXN_CCY='CNY'))
AND A.TRN_REF_NO =B.Contract_Ref_No(+)
AND E.PRODUCT_CODE=A.PRODUCT_CODE
and D.BRANCH_CODE=A.TXN_BRANCH
AND A.TXN_BRANCH = F.branch_code(+)
AND A.TXN_BRANCH = G.branch_code
AND DECODE(A.DR_ACC,'OFS',OFS_ACC,TXN_ACC) =F.cust_ac_no(+)
UNION
SELECT 	 A.REFERENCE_NO,
      A.TXN_BRANCH BRANCH,
      A.PRODUCT_CODE, --
			Decode(TXN_DRCR,'D',OFFSET_CCY,TXN_CCY) CR_CCY,
			Decode(TXN_DRCR,'D',TXN_CCY,OFFSET_CCY) DR_CCY, 
			decode(TXN_DRCR,'D',OFFSET_AMOUNT,TXN_AMOUNT) CR_AMOUNT,
  		decode(TXN_DRCR,'D',TXN_AMOUNT,OFFSET_AMOUNT) DR_AMOUNT,
			B.FIELD_VAL_2 CODE,  
      decode(TXN_DRCR,'D',TXN_ACCOUNT,OFFSET_ACCOUNT) "Account No",-- Only one field so reporting debit account 
      A.EXCH_RATE "EXCHANGE_RATE", --
      E.TXN_MIS_1 "DB Product", --
      A.REL_CUSTOMER "CIF Number", --
			(SELECT   LOV_DESC FROM UDTM_LOV WHERE FIELD_NAME	 ='TRANSACTION CODE' AND    LOV	=B.FIELD_VAL_2  ) DESCRIPTION,
			TXN_DATE ACCOUNTING_DATE,
            Bo_Amt1_To_Amt2_Usd(TXN_BRANCH, Decode(TXN_DRCR,'D',TXN_CCY,OFFSET_CCY), decode(TXN_DRCR,'D',TXN_AMOUNT,OFFSET_AMOUNT)) USD_AMOUNT
FROM
	DETB_TELLER_MASTER  A,
	CSTM_CONTRACT_USERDEF_FIELDS B,
	STTM_DATES D,
	 MITM_PRODUCT_DEFAULT E
WHERE TXN_DATE BETWEEN TRUNC(TODAY) AND TODAY
AND ((TXN_CCY<>'CNY' AND OFFSET_CCY='CNY') OR (OFFSET_CCY<>'CNY' AND TXN_CCY='CNY'))
AND A.REFERENCE_NO =B.Contract_Ref_No(+)
AND E.PRODUCT_CODE=A.PRODUCT_CODE
AND A.TXN_BRANCH=D.BRANCH_CODE
AND A.RECORD_STAT='L' AND A.AUTH_STAT='A'
/

SELECT  
		SUBSTR(TRN_REF_NO,1,3) TRN_BRANCH,
		MODULE, 
		TRN_REF_NO, 
		RELATED_ACCOUNT,
		RELATED_CUSTOMER
		EVENT_SR_NO, 
		Event, 
		AC_ENTRY_SR_NO, 
		AC_BRANCH, 
		AC_NO, 
		AC_CCY, 
		DRCR_IND, 
		TRN_CODE, 
		AMOUNT_TAG,
		FCY_AMOUNT, 
		LCY_AMOUNT,
		TRN_DT, 
		VALUE_DT,
		IB,
DECODE(PRODUCT,'IITC','FOREIGN','LOCAL')  Distinction
FROM 		ACTB_DAILY_LOG A
WHERE 		DELETE_STAT != 'D'
AND	IB = 'Y'
AND AC_BRANCH IN('910','911','912')
AND EXISTS
(
	  SELECT 1 
	  FROM	ACTM_IB_SETUP
	  WHERE	(due_to_branch2 = a.AC_NO OR due_from_branch2 = a.AC_NO
	  OR due_to_branch1 = a.AC_NO OR due_from_branch1 = a.AC_NO)
)
/

SELECT today,
A.BRANCH_CODE,
B.BRANCH_NAME,
a.GL_CODE,c.AC_GL_DESC,a.CCY_CODE, 
  DECODE(a.ccy_code,b.branch_lcy,(OPEN_cr_bal_lcy-OPEN_dr_bal_lcy),(OPEN_cr_bal-OPEN_dr_bal)) open_balance,
DECODE(a.ccy_code,b.branch_lcy,(cr_bal_lcy-dr_bal_lcy),(cr_bal-dr_bal)) balance
FROM gltb_gl_bal a,
	   	 sttms_branch b,
		 sttb_account c,
		 sttm_dates d
WHERE a.branch_code = b.branch_code
AND   a.period_code = b.current_period
AND   a.fin_year = b.current_cycle
AND   a.ccy_code  !='CNY'
AND   EXISTS
	  (
	  SELECT 1 
	  FROM	ACTM_IB_SETUP
	  WHERE	(due_to_branch2 = a.gl_code OR due_from_branch2 = a.gl_code
	  OR due_to_branch1 = a.gl_code OR due_from_branch1 = a.gl_code))
AND c.AC_GL_NO=a.GL_CODE	
AND d.branch_code=a.branch_code  
UNION
SELECT a.TRN_DT,
A.AC_BRANCH,
B.BRANCH_NAME,
a.AC_NO,c.AC_GL_DESC,AC_CCY,NULL,
DECODE(a.AC_CCY,b.branch_lcy,LCY_AMOUNT,FCY_AMOUNT) balance
FROM ACTB_daily_log  a,
	   	sttms_branch b,
		sttb_account c
WHERE a.ac_branch = b.branch_code
AND   a.period_code = b.current_period
AND   a.FINANCIAL_CYCLE = b.current_cycle
AND   a.AC_CCY  !='CNY'
AND   a.BALANCE_UPD<>'U'
AND   a.DELETE_STAT<>'D'
AND   EXISTS
	  (
	  SELECT 1 
	  FROM	ACTM_IB_SETUP
	  WHERE	(due_to_branch2 = a.AC_NO OR due_from_branch2 = a.AC_NO
	  OR due_to_branch1 = a.AC_NO OR due_from_branch1 = a.AC_NO))
AND c.AC_GL_NO=a.AC_NO	  
/
