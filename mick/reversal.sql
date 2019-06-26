DECLARE
        l_tb_hoff_base  ACPKSS.tbl_AcHoff;
        l_tb_hoff       ACPKSS.tbl_AcHoff;
        l_branch        VARCHAR2 (3) := '&1';
        l_batch         VARCHAR2 (4) := '&2';
        l_error_code    VARCHAR2(2000);
        l_error_param   VARCHAR2(2000);
BEGIN
	global.pr_init(l_branch,'SYSTEM');
	global.set_func_type('B');
	for i in
		(
		select	*
		from	actbs_daily_log
		where	ac_branch = l_branch
		and	batch_no = l_batch
		and	delete_stat != 'D'
		and	module = 'DE'
		)
	loop
		l_tb_hoff.delete;
		l_tb_hoff(1) := i;
		l_tb_hoff(1).NETTING_IND := 'N';
		l_tb_hoff(1).lcy_amount := -1 * l_tb_hoff(1).lcy_amount;
		l_tb_hoff(1).fcy_amount := -1 * l_tb_hoff(1).fcy_amount;
		savepoint sp_ac;
		l_error_code := null;
		l_error_param := null;
		ovpkss.pr_initerrtbl;
                IF NOT acpkss.fn_achandoff
                                (
                                l_tb_hoff(1).trn_ref_no,
                                l_tb_hoff(1).event_sr_no,
                                GLOBAL.application_date,
                                l_tb_hoff,
                                'B',
                                'N',
                                'N',
                                GLOBAL.user_id,
                                l_error_code,
                                l_error_param
                                )
                THEN
                        DEBUG.pr_debug('GL','ACPKS.fn_achandoff returned FALSE '||l_error_code);
			rollback to sp_ac;
			raise_application_error(-20001,'Error in REversing '||l_tb_hoff(1).trn_ref_no||' :: '||l_error_code);
                END IF;
	end loop;
end;
/


