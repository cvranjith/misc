set line 9999
select a.branch_code brn,today , NEXT_WORKING_DAY, PREV_WORKING_DAY, decode(end_of_input,'N','Transaction Input','T','EOTI','F','EOFI','E','EOD',
'B','BOD',end_of_input) status from sttm_dates a,sttm_branch b where a.branch_code = b.branch_code
and b.record_stat='O'
/
