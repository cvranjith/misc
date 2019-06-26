-- CREATE OBJECTS THAT MAY HAVE BEEN MISSING
set verify off
undef HOST_NAME TITLE_BAR_TEXT FLEXCUBE_USERNAME FLEXCUBE_PASSWORD FMX_PATH HELP_ALIAS ADV_PATH ADV_ALIAS WORK_AREA EMS_IN_PATH EMS_OUT_PATH FIPM_PATH

prompt
accept FLEXCUBE_USERNAME CHAR prompt  'Enter FLEXCUBE Schema Name           ==> '
prompt
accept FLEXCUBE_PASSWORD CHAR prompt  'Enter FLEXCUBE Password              ==> ' hide
prompt
accept HOST_NAME CHAR prompt          'Enter Connect String                 ==> '
prompt
accept TITLE_BAR_TEXT CHAR prompt     'Enter Title Bar Text                 ==> '
prompt
accept HELP_ALIAS CHAR prompt         'Enter HELP Alias                     ==> '
prompt
accept ADV_ALIAS CHAR prompt          'Enter ADV Alias                      ==> '
prompt
accept ADV_PATH CHAR prompt           'Enter ADV Path (of App Server)       ==> '
prompt
accept FMX_PATH CHAR prompt           'Enter FMX Path (of App Server)       ==> '
prompt
accept EMS_IN_PATH CHAR prompt        'Enter EMS IN Path (of EMS Server)    ==> '
prompt
accept EMS_OUT_PATH CHAR prompt       'Enter EMS OUT Path (of EMS Server)   ==> '
prompt
accept BO_PATH CHAR prompt            'Enter BO Path (of BO Server)         ==> '
prompt
accept WORK_AREA CHAR prompt          'Enter WORK_AREA Path (of DB Server)  ==> '
prompt
accept FIPM_PATH CHAR prompt          'Enter FIPM_PATH Path (of DB Server)  ==> '
prompt



create or replace synonym FCT_KILL_SESSION for sys.FCT_KILL_SESSION
/
set trimspool on pages 0 line 9999 feed off
-- REMOVE ALL THE JOBS 
begin
	for i in
		(
		select	job
		from	user_jobs
		)
	loop
		dbms_job.remove(i.job);
	end loop;
end;
/

-- ENABLE TRIGGERS AND CONSTRAINTS

spo tmp.tmp
SELECT DISTINCT 'ALTER TABLE '||TABLE_NAME||' ENABLE ALL TRIGGERS;'
FROM USER_TRIGGERS WHERE STATUS = 'DISABLED'
/
SELECT DISTINCT 'ALTER TABLE '||TABLE_NAME||' ENABLE CONSTRAINT '||CONSTRAINT_NAME||';'
FROM USER_CONSTRAINTS WHERE STATUS = 'DISABLED'
/
spo off
set feed on
@tmp.tmp

-- COMPILE INVALID SOURCE

spo comp.inv
prompt set feedback off
prompt spool tmp.tmp
prompt select 'ALTER '|| decode (object_type, 'PACKAGE BODY', 'PACKAGE',object_type)
prompt        || ' ' || object_name|| ' ' ||
prompt    decode (object_type, 'PACKAGE BODY', 'COMPILE BODY;','COMPILE;')
prompt from user_objects where  STATUS  = 'INVALID' order by  object_type
prompt /
prompt spool off
prompt set feedback on
prompt @tmp.tmp
spo OFF

@comp.inv
@comp.inv
@comp.inv


spo tmp.tmp
REM
spo OFF


set verify off


UPDATE STTM_BRANCH SET HOST_NAME = '&&HOST_NAME'
/
UPDATE STTM_CUSTOMER SET LIAB_NODE = '&&HOST_NAME'
/
UPDATE LMTB_OFFLINE_NODES SET NODE_NAME = '&&HOST_NAME'
/
UPDATE ICTB_ACC_ACTION SET NODE = '&&HOST_NAME'
/
UPDATE ICTB_ACTION_LOG SET NODE = '&&HOST_NAME'
/
UPDATE LMTB_OFFLINE_UTILS SET NODE_NAME = '&&HOST_NAME'
/
UPDATE MSTB_COMMSG_MASTER SET NODE = '&&HOST_NAME'
/
UPDATE MSTB_CURRENT_MSG_IND_OUT SET NODE = '&&HOST_NAME'
/
UPDATE MSTB_DLY_MSG_IN SET NODE = '&&HOST_NAME'
/
UPDATE MSTB_DLY_MSG_IN_HIST SET NODE = '&&HOST_NAME'
/
UPDATE MSTB_DLY_MSG_OUT SET NODE  = '&&HOST_NAME'
/
UPDATE MSTM_MCS SET NODE = '&&HOST_NAME'
/
UPDATE MSTM_UNDO set node = '&&HOST_NAME'
/
UPDATE STTM_UPLOAD_CUSTOMER SET LIAB_NODE = '&&HOST_NAME'
/
UPDATE SMTB_USER_REG SET PARAM_VALUE = '&&FMX_PATH' WHERE PARAM_NAME = 'FORMS60_PATH'
/
UPDATE SMTB_SYSTEM_REG SET PARAM_VALUE = '&&FMX_PATH' WHERE PARAM_NAME = 'FORMS60_PATH'
/


DECLARE
	FLEXCUBE_U	VARCHAR2 (100) := UPPER('&&FLEXCUBE_USERNAME');
	FLEXCUBE_P	VARCHAR2 (100) := UPPER('&&FLEXCUBE_PASSWORD');
	FLEXCUBE_H	VARCHAR2 (100) := UPPER('&&HOST_NAME');
	EU	VARCHAR2 (100);
	EP	VARCHAR2 (100);
BEGIN
	EU := SMPKS.FN_ENCRYPT_APP_PASSWORD (FLEXCUBE_U,'CITIL');
	EP := SMPKS.FN_ENCRYPT_APP_PASSWORD (FLEXCUBE_P,FLEXCUBE_U);
	UPDATE	STTMS_HOST
	SET		USERNAME = EU,
			HOST_NAME = '&&HOST_NAME',
			PASSWORD = EP;
END;
/

UPDATE smtb_user_reg set param_value = '&&TITLE_BAR_TEXT' WHERE PARAM_NAME= 'TITLE_BAR_TEXT'
/
UPDATE smtb_system_reg set param_value = '&&TITLE_BAR_TEXT' WHERE PARAM_NAME= 'TITLE_BAR_TEXT'
/
UPDATE smtb_user_reg set param_value = '&&HELP_ALIAS' WHERE PARAM_NAME= 'HELP_PATH'
/
UPDATE smtb_system_reg set param_value = '&&HELP_ALIAS' WHERE PARAM_NAME= 'HELP_PATH'
/
UPDATE cstb_param set param_val = '&&ADV_ALIAS' WHERE PARAM_NAME = 'OAS_PRINT_URL'
/
UPDATE cstb_param set param_val = '&&ADV_PATH' WHERE PARAM_NAME = 'OAS_PRINT_FILE_PATH'
/
UPDATE cstb_param set param_val = '&&HELP_ALIAS'||'/upload_signature.html' WHERE PARAM_NAME = 'SV_UPLD_URL'
/
UPDATE cstb_param set param_val = '/tmp/' WHERE PARAM_NAME = 'SV_DIR'
/
update cstb_param set param_val = 'WORK_AREA' where param_name = 'WORK_AREA'
/
update mstm_mcs set out_dir = '&EMS_OUT_PATH', in_dir = '&EMS_IN_PATH' where media = 'SWIFT'
/
update iftms_fipm_files_maint set FILE_PATH = 'FIPM_PATH'
/
update BOTM_AUTOREFRESH_PARAMS set template_path = '&BO_PATH', output_path = '&BO_PATH'||'\PUBLISHED', log_path = '&BO_PATH'||'\LOG'
/
create or replace directory WORK_AREA as '&WORK_AREA'
/
create or replace directory FIPM_PATH as '&FIPM_PATH'
/
update cstb_param set param_val = '&&HELP_ALIAS'||'/close.html' WHERE PARAM_NAME = 'CLOSE_HTML'
/

COMMIT;

