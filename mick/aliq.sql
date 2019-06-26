declare
			p_account varchar2(35) := 'ACULOOL120600011';
			p_branch   varchar2(3) := substr(p_account,1,3);            
			p_error_code   ertbs_msgs.err_code%type;
			p_error_param  ertbs_msgs.message%type;
			l_account_obj clpkss_object.ty_rec_account;
begin
            global.pr_init(p_branch, 'SYSTEM');
            clpkss_batch.g_commit_freq := 1000;
            debug.pr_debug('CL','Going to insert one ALIQ entry');
						IF NOT clpkss_object.fn_create_acct_object(p_account,
																											 p_branch,
																											 l_account_obj,
																											 p_error_code,
																											 p_error_param)
						THEN
								raise_application_error(-20001,'Failed wit clpkss_object.fn_create_acct_object with :-(' || p_error_code || p_error_param);
								RETURN;
						END IF;            
						debug.pr_debug('CL','Going to call fn_aliq_for_an_account');
						IF NOT clpkss_liqd.fn_aliq_for_an_account(p_account,
															p_branch,
															global.application_date,
															p_error_code,
															p_error_param)
						THEN
							 raise_application_error(-20001,'clpkss_liqd.fn_aliq_for_a_day failed with :-( ' || p_error_code || p_error_param);
						END IF;  
					   IF NOT clpkss_accounting.fn_accounting_for_loanac(p_branch,
																				p_account,
																			   global.application_date,
																			   p_error_code,
																			   p_error_param)
						THEN
								ROLLBACK;
									raise_application_error(-20001,'clpkss_accounting.fn_accounting_for_branch failed with :-(' || p_error_code || p_error_param);
						END IF;
end;
/
