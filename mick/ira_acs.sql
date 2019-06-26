select a.cust_no, substr(c.customer_name1, 1, 30) cust_name, a.cust_ac_no, a.branch_code, a.account_class, a.ACY_AVL_BAL, a.ac_stat_de_post, a.auth_stat
from sttm_cust_account a, sttm_customer c
where a.branch_code = 'IRA'
and c.customer_no = a.cust_no
--and ac_stat_de_post = 'N'
order by a.cust_no, a.cust_ac_no, a.account_class
/
