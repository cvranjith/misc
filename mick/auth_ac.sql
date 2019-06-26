DECLARE
	l_err 	VARCHAR2(1000);
	l_par 	VARCHAR2(1000);
BEGIN
	FOR i IN 
		(
		SELECT	distinct TRN_REF_NO,EVENT_SR_NO
		FROM	ACTBS_DAILY_LOG
		WHERE	DELETE_STAT <> 'D'
		AND 	auth_stat = 'U'
                AND RELATED_REFERENCE LIKE '%ZASP%'
		order by trn_Ref_no
		)
	LOOP
		IF NVL(GLOBAL.current_branch,'%*!') <> SUBSTR(i.trn_ref_no,1,3)
		THEN
			GLOBAL.pr_init(SUBSTR(i.trn_ref_no,1,3),'SYSTEM');
		END IF;
		IF ACPKSS.fn_acservice
   			(
			global.current_branch,
			global.application_date,
			global.lcy,
			i.trn_ref_no ,
			i.event_sr_no ,
			'A' ,
			global.user_id ,
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
