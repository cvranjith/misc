Select     Sum(decode(category,'5',0,'6',0,decode(drcr_ind,'D',lcy_amount,0)))
           real_dr,
   Sum(decode(category,'5',0,'6',0,decode(drcr_ind,'C',lcy_amount,0)))
           real_cr,
   Sum(decode(category,'1',0,'2',0,'3',0,'4',0,'7',0,
                   decode(drcr_ind,'D',lcy_amount,0))) cont_dr,
   Sum(decode(category,'1',0,'2',0,'3',0,'4',0,'7',0,
                   decode(drcr_ind,'C',lcy_amount,0))) cont_cr,
   financial_cycle, period_code
   FROM ACTBS_DAILY_LOG
   WHERE ac_branch='&branch'
   AND balance_upd='U' AND nvl(delete_stat,'X') <> 'D'
   GROUP BY financial_cycle, period_code
/
