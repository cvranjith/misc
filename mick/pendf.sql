select *from eitb_pending_programs
where branch_Code in (select branch_Code from sttm_branch where record_stat = 'O')
and function_id like REPLACE(upper('%&Func%'),' ','%')
ORDER BY RUN_STAT ASC,function_id
/
