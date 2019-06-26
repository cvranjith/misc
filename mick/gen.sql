undef dcn
SET LONG 9999
DECLARE
	l_ret_dcn       VARCHAR2(32000);
	l_cur_msghoff   MSPKSS.msg_handoff_curtype;
BEGIN
global.pr_init(substr('&&DCN',1,3),'SYSTEM');
	update MSTBS_MSG_HANDOFF set msg_status = 'N' where DCN = '&&DCN';
	OPEN	l_cur_msghoff
	FOR	SELECT  *
        FROM    MSTBS_MSG_HANDOFF
        WHERE   --msg_status = 'N'
	--AND
	DCN = '&&DCN';
	IF NOT MSPKSS.fn_on_gen_msg_out (l_cur_msghoff, l_ret_dcn)
	THEN
		NULL;
	END IF;
END;
/

SELECT MESSAGE FROM MSTB_DLY_MSG_OUT WHERE DCN = '&&DCN'
/
undef dcn
