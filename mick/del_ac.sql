--- should not be run for Customer Accounts.

DECLARE
	l_err 	VARCHAR2(1000);
	l_par 	VARCHAR2(1000);
BEGIN
	FOR i IN 
		(
		SELECT	TRN_REF_NO,EVENT_SR_NO,AC_CCY,AC_BRANCH,USER_ID
		FROM	ACTBS_DAILY_LOG
		WHERE	DELETE_STAT <> 'D'
		AND 	BATCH_NO = 'cm02'
		)
	LOOP
		IF NVL(GLOBAL.current_branch,'%*!') <> SUBSTR(i.trn_ref_no,1,3)
		THEN
			GLOBAL.pr_init(SUBSTR(i.trn_ref_no,1,3),NVL(i.user_id,'SYSTEM'));
		END IF;
		
		IF ACPKSS.fn_acservice
   			(
			i.AC_BRANCH ,
			global.application_date,
			i.AC_CCY    ,
			i.trn_ref_no ,
			i.event_sr_no ,
			'D' ,
			i.user_id ,
			l_err,
			l_par	
		   	)
		THEN
			DEBUG.PR_DEBUG('AC','SUCCESS - '||i.trn_ref_no);
		ELSE
		    	raise_application_error(-20001,'Err '||l_err);
		END IF;
	END LOOP;
END;
/
