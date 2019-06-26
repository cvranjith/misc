prompt REAL
SELECT   a.branch_code,fin_year,period_Code,nvl(SUM(nvl(cr_bal_lcy,0)-nvl(dr_bal_lcy,0)),0) mismatch
      FROM  gltbs_gl_bal a,
            sttms_branch b
      WHERE leaf = 'Y'
      AND (category IN ('1','2') or (category in ('3','4') and ccy_code=branch_lcy))
      AND  a.branch_code = b.branch_code
      and period_code = current_period
      and fin_year = current_cycle
      group by a.branch_code,fin_year,period_Code
/
prompt CONT
SELECT   a.branch_code,fin_year,period_Code,nvl(SUM(nvl(cr_bal_lcy,0)-nvl(dr_bal_lcy,0)),0) mismatch
      FROM  gltbs_gl_bal a,
            sttms_branch b
      WHERE leaf = 'Y'
      AND category IN ('5','6')
      AND  a.branch_code = b.branch_code
      and period_code = current_period
      and fin_year = current_cycle
      group by a.branch_code,fin_year,period_Code
/
prompt POS
SELECT   a.branch_code,fin_year,period_Code,nvl(SUM(nvl(cr_bal_lcy,0)-nvl(dr_bal_lcy,0)),0) mismatch
      FROM  gltbs_gl_bal a,
            sttms_branch b
      WHERE leaf = 'Y'
      AND category IN ('8','9')
      AND  a.branch_code = b.branch_code
      and period_code = current_period
      and fin_year = current_cycle
      group by a.branch_code,fin_year,period_Code
/
