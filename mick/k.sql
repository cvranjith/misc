undef CRN

SELECT CONTRACT_REF_NO,EVENT_CODE,EVENT_SEQ_NO
FROM CSTB_CONTRACT_EVENT_LOG
WHERE MAKER_ID like 'IFLEX%'
AND AUTH_STATUS = 'U'
/
UPDATE CSTB_CONTRACT_EVENT_LOG
SET MAKER_ID ='SYSTEM'
WHERE MAKER_ID like 'IFLEX%'
AND AUTH_STATUS = 'U'
AND CONTRACT_rEF_NO = '&&CRN'
/
UPDATE LDTB_CONTRACT_CONTROL
SET ENTRY_BY = 'SYSTEM'
WHERE CONTRACT_REF_NO = '&&CRN'
/
commit;
