set head on
SET TIMING ON
set array 1
set linesize 10000
set pagesize 50000
set long 1000000
set echo on
set trimspool on

spool c:\custminusallac.spl
show user;
select a.branch_code , cust_ac_no , ccy , acy_curr_balance , lcy_curr_balance
from sttms_cust_account a
minus
select 
ac_branch , ac_no , ac_ccy ,
sum(decode(drcr_ind,'D',-1,1) * decode(ac_ccy,branch_lcy,lcy_amount,nvl(fcy_amount,0))) acy,
sum((decode(drcr_ind,'D',-1,1) * lcy_amount)) lcy
from
acvw_all_ac_entries a , sttms_branch b
where a.ac_branch = b.branch_code
and a.balance_upd ='U' 
group by ac_branch , ac_no , ac_ccy
/

-- Query 2 account balances minus entries

select 
ac_branch , ac_no , ac_ccy ,
sum(decode(drcr_ind,'D',-1,1) * decode(ac_ccy,branch_lcy,lcy_amount,nvl(fcy_amount,0))) acy,
sum((decode(drcr_ind,'D',-1,1) * lcy_amount)) lcy
from
acvw_all_ac_entries a , sttms_branch b
where a.ac_branch = b.branch_code
and cust_gl = 'A'
and a.balance_upd ='U' 
group by ac_branch , ac_no , ac_ccy
minus
select a.branch_code , cust_ac_no , ccy , acy_curr_balance , lcy_curr_balance
from sttms_cust_account a
/

spool off