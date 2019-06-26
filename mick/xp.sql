
accept CRN PROMPT 'Enter the contract reference no ==> '
set head on
set array 1
set linesize 10000
set pagesize 50000
set long 10000
set echo on
set colsep ";"
set trimspool on
SPOOL /tmp/XP_DETAILS.&&CRN..SPL

PROMPT XPTBS_BUDGET_UTILS
SELECT * FROM XPTBS_BUDGET_UTILS where contract_ref_no=upper('&CRN')
/
PROMPT XPTBS_CONTRACT_DOCUMENTS
SELECT * FROM XPTBS_CONTRACT_DOCUMENTS WHERE contract_ref_no=upper('&CRN')
/
PROMPT XPVW_CONTRACT_LIQ
select * from XPVW_CONTRACT_LIQ where contract_ref_no=upper('&CRN')
/
PROMPT XPTBS_CONTRACT_LIQ
SELECT * FROM XPTBS_CONTRACT_LIQ where contract_ref_no=upper('&CRN')
/
PROMPT XPTBS_CONTRACT_MASTER
SELECT * FROM XPTBS_CONTRACT_MASTER where contract_ref_no=upper('&CRN')
/
PROMPT XPTBS_ITEM_PMT_DETAILS
SELECT * FROM XPTBS_ITEM_PMT_DETAILS where contract_ref_no=upper('&CRN')
/
PROMPT XPTBS_REFUND_DETAILS
SELECT * FROM XPTBS_REFUND_DETAILS where contract_ref_no=upper('&CRN')
/
PROMPT XPTMS_BRANCH_PARAMETERS
SELECT * FROM XPTMS_BRANCH_PARAMETERS
/
PROMPT XPTMS_BUDGET_CODE
SELECT * FROM XPTMS_BUDGET_CODE
/
PROMPT XPTMS_BUDGET_DETAILS
SELECT * FROM XPTMS_BUDGET_DETAILS
/
PROMPT XPTMS_PRODUCT_DOCS
Select * from XPTMS_PRODUCT_DOCS where product_code = UPPER(SUBSTR('&CRN',4,4))
/
PROMPT XPTMS_PRODUCT_MASTER
Select * from XPTMS_PRODUCT_MASTER where product_code = UPPER(SUBSTR('&CRN',4,4))
/
PROMPT CSTB_CONTRACT
SELECT * FROM CSTB_CONTRACT WHERE CONTRACT_REF_NO = UPPER('&CRN')
/
PROMPT CSTB_CONTRACT_EVENT_LOG
SELECT * FROM CSTB_CONTRACT_EVENT_LOG WHERE CONTRACT_REF_NO = UPPER('&CRN')
/
PROMPT CSTBS_CONTRACT_EVENT_ADVICE
select * from CSTBS_CONTRACT_EVENT_ADVICE WHERE CONTRACT_REF_NO = UPPER('&CRN')
/
PROMPT CSTBS_CONTRACT_OVD
select * from CSTBS_CONTRACT_OVD WHERE CONTRACT_REF_NO = UPPER('&CRN')
/
--PROMPT cstb_contract_change_log
--SELECT * FROM cstb_contract_change_log  WHERE CONTRACT_REF_NO = UPPER('&CRN')
--/
PROMPT ACVWS_ALL_AC_ENTRIES
select * from ACVWS_ALL_AC_ENTRIES WHERE TRN_REF_NO = UPPER('&CRN')
/

PROMPT ISTBS_CONTRACTIS
SELECT * FROM ISTBS_CONTRACTIS  WHERE CONTRACT_REF_NO = UPPER('&CRN')


SELECT * FROM 	xptms_vnd_mst
	WHERE vendor_code = (SELECT vendor_id
				   FROM XPTB_CONTRACT_MASTER
				   WHERE	contract_ref_no = UPPER('&CRN')
					AND	event_seq_no    = (SELECT MAX(event_seq_no)    
									FROM xptbs_contract_master
									WHERE contract_ref_no = UPPER('&CRN')));

PROMPT CSTMS_PRODUCT_EVENT_ADVICE
SELECT * FROM CSTMS_PRODUCT_EVENT_ADVICE WHERE PRODUCT_CODE = SUBSTR('&CRN',4,4)
ORDER BY PRODUCT_CODE, EVENT_CODE, MSG_TYPE ;

spool off
