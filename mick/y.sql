/*
	Before run this script, Pls run: get_ld_uploadfile.sql again.
*/

DECLARE
	
	l_error_code		VARCHAR2(10000);
	l_error_parameter	VARCHAR2(10000);
	l_alert_return		VARCHAR2(10);
	l_upload_id		ldtbs_upload_liq_summary.upload_id%TYPE;
	l_uploaded_auth		cstbs_upload_log.uploaded_auth%TYPE;
	l_uploaded_unauth	cstbs_upload_log.uploaded_unauth%TYPE;
	l_rejected		cstbs_upload_log.rejected%TYPE;
BEGIN
	GLOBAL.pr_init('&brn','SYSTEM');
	IF NOT  ldpkss_upload_payment_0.fn_upload_for_a_branch
		(
		'VNDIVB'
		,'U'
		,'R'
		,'I'
		,l_upload_id
		,l_error_code
		,l_error_parameter
		)		
	THEN
		DEBUG.pr_debug('LD','error '||l_error_code);
	END IF;
END;
/

