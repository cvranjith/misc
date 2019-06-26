begin
for i in (
SELECT * FROM
(
select  CONTRACT_REF_NO,
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
from    lctb_CONTRACT_MASTER A
WHERE   CREDIT_LINE IS NOT NULL
AND     EVENT_SEQ_NO = (SELECT MAX(EVENT_SEQ_NO) FROM LCTB_CONTRACT_MASTER WHERE CONTRACT_rEF_NO = A.CONTRACT_REF_NO)
)
WHERE nvl(UTIL,0) <> nvl(OS_LIAB,0)
)
loop
	pr_lc_lm_rebuild(i.contract_ref_no);
end loop;
end;
/
