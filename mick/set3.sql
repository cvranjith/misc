set head on
set array 1
set linesize 10000
set pagesize 50000
set long 1000000
set echo on
set trimspool on
spool c:\glbalminusallac2.spl
show user;
--PNL

Prompt Please Specify Period START_DATE:  
accept START_DATE

Prompt Please Specify BRANCH:  
accept BRN

Prompt Please Specify CURRENCY:  
accept CCY

select a.branch_code , a.gl_code , 
cr_bal_lcy - dr_bal_lcy
from gltb_gl_bal a , gltm_glmaster b , sttms_period_codes c
where
a.category in ('3','4')
and a.leaf = 'Y'
and customer = 'I'
and a.gl_code = b.gl_code
and ccy_code = upper('&CCY')
and a.period_code = c.period_code
and a.fin_year = c.fin_cycle
and pc_start_date = '&START_DATE'
and
(((cr_bal - dr_bal) <> 0) OR ((cr_bal_lcy - dr_bal_lcy) <> 0))
and a.branch_code = '&BRN'
MINUS
select ac_branch , ac_no , 
sum(decode(drcr_ind , 'D', -1,1) * lcy_amount) lcy
from acvws_all_ac_entries a, sttms_period_codes b
where
category in ('3','4')
and cust_gl = 'G'
and
a.period_code = b.period_code
and
a.financial_cycle = b.fin_cycle
and
pc_start_date <= '&START_DATE'
and 
a.ac_branch = '&BRN'
and a.balance_upd ='U'
group by ac_branch , ac_no 
/


select ac_branch , ac_no , 
sum(decode(drcr_ind , 'D', -1,1) * lcy_amount) lcy
from acvws_all_ac_entries a, sttms_period_codes b
where
category in ('3','4')
and cust_gl = 'G'
and
a.period_code = b.period_code
and
a.financial_cycle = b.fin_cycle
and
pc_start_date <= '&START_DATE'
and 
a.ac_branch = '&BRN'
and a.balance_upd ='U' 
group by ac_branch , ac_no 
MINUS
select a.branch_code , a.gl_code , 
cr_bal_lcy - dr_bal_lcy
from gltb_gl_bal a , gltm_glmaster b , sttms_period_codes c
where
a.category in ('3','4')
and a.leaf = 'Y'
and customer = 'I'
and a.gl_code = b.gl_code
and ccy_code = upper('&CCY')
and a.period_code = c.period_code
and a.fin_year = c.fin_cycle
and pc_start_date = '&START_DATE'
and
(((cr_bal - dr_bal) <> 0) OR ((cr_bal_lcy - dr_bal_lcy) <> 0))
and a.branch_code = '&BRN'
/

spool off