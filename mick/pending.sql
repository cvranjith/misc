SET HEAD OFF
select *from eitb_pending_programs 
where branch_Code in (select branch_Code from sttm_branch where record_stat = 'O')
ORDER BY RUN_STAT ASC,function_id
/
/*
SELECT 'CURRENTLY RUNNING '||BRANCH_CODE||' -> '||FUNCTION_ID FROM AETB_PROCESS_STATUS
WHERE RUN_STAT ='X'
*/
SET HEAD ON
