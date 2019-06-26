UNDEF DATE
select 'INTERPAY FILE '||count(*)||' '|| sum(a.cr_amount)
from fttbs_contract_master a , istbs_contractis c
WHERE 
c.contract_ref_no = a.contract_ref_no
and c.account = a.cr_account
and nvl(c.interpay_generated,'N') = 'Y'
and c.pay_receive = 'P'
and c.account = 'INTERP'
and c.acc_ccy = 'NLG'
and c.generation_date = 
NVL('&&DATE',(SELECT TODAY FROM STTM_DATES))

select 
sum(a.cr_amount) 
--COUNT(1)
from  
fttbs_contract_master a , 
istbs_contractis c,
sttm_customer b,
sttms_cust_account d
WHERE 
c.contract_ref_no = a.contract_ref_no
and c.account = a.cr_account
and nvl(interpay_generated,'N') = 'Y'
and pay_receive = 'P'
and account = 'INTERP'
and a.cr_amount > 0
and a.dr_Account = d.cust_ac_no
and d.cust_no = b.customer_no
and nvl(a.source_code,' ') <> 'FCIS'
and generation_date = '01-06-2001'
/

UNDEF DATE
