
declare
procedure pr(p_user in varchar2,p_name in varchar2)
is
        U       VARCHAR2(100) := p_user;
        N       NUMBER;
        P       VARCHAR2(100);
        H       VARCHAR2(100) := global.head_office;
        D       DATE;
	r	varchar2(1000) := 'SMS ADMIN';
BEGIN
	delete smtb_user where user_id = u;
	delete smtb_user_role where user_id = u;

        P := SMPKS.FN_ENCRYPT_PASSWORD(UPPER('NATIXIS09'),U);
        D := TO_DATE(TO_CHAR(GLOBAL.APPLICATION_DATE,'YYYYDDD')||TO_CHAR(SYSDATE,'HH24MISS'),'YYYYDDDHH24MISS');

        INSERT INTO SMTB_USER
                (EXIT_FUNCTION,USER_ID,START_DATE,USER_NAME,USER_PASSWORD,STATUS_CHANGED_ON,TILL_ALLOWED,ACCLASS_ALLOWED,
                PRODUCTS_ALLOWED,BRANCHES_ALLOWED,LAST_SIGNED_ON,MAX_OVERRIDE_AMT,TIME_LEVEL,USER_CATEGORY,USER_STATUS,
                END_DATE,PWD_CHANGED_ON,MAX_TXN_AMT,MAX_AUTH_AMT,NO_CUMULATIVE_LOGINS,NO_SUCCESSIVE_LOGINS,FORCE_PASSWD_CHANGE,
                USER_LANGUAGE,STARTUP_FUNCTION,HOME_BRANCH,FWDREW_COUNT,GL_ALLOWED,AUTH_STAT,CHECKER_DT_STAMP,CHECKER_ID,
                MAKER_DT_STAMP,MAKER_ID,MOD_NO,ONCE_AUTH,RECORD_STAT,USER_PASSWORD_BRN,USER_ID_BRN,USER_TXN_LIMIT,LIMITS_CCY,
                AUTO_AUTH,PROPAGATE_TO_WORKFLOW,CUSTOMER_NO,PRODUCTS_ACCESS_ALLOWED)
        VALUES
                ('',u,GLOBAL.APPLICATION_DATE,p_name,P,'','A','D','D','D',NULL,
                NULL,9,'S','E',GLOBAL.MAX_DATE,GLOBAL.APPLICATION_DATE,NULL,NULL,1,0,0,'ENG','',h,NULL,'D','A',
                D,'SYSTEM',D,'SYSTEM',1,'Y','O','','','N','','','','','D');

        FOR I IN (SELECT BRANCH_CODE FROM STTM_BRANCH WHERE RECORD_STAT = 'O')
        LOOP
                DELETE  SMTB_USER_ROLE
                WHERE   USER_ID = U
                AND     BRANCH_CODE = I.BRANCH_CODE
                AND     ROLE_ID = r;

                INSERT INTO SMTB_USER_ROLE
                        (
                        ROLE_ID,
                        USER_ID,
                        AUTH_STAT,
                        BRANCH_CODE
                        )
                VALUES
                        (
                        r,
                        u,
                        'A',
                        I.BRANCH_CODE
                        );
        END LOOP;

        DELETE SMTB_MSGS_RIGHTS
        WHERE USER_ROLE_ID = U
        AND USER_ROLE_FLAG = 'U';

        INSERT INTO SMTB_MSGS_RIGHTS
                (USER_ROLE_ID,USER_ROLE_FLAG,GENERATE,HOLD,CANCEL,TEST_INPUT,CHANGE_NODE,CHANGE_ADDR,RELEASE,REINSTATE,
                CHANGE_MEDIA,CHANGE_PRIOR,BRANCH_MOVE,PRINT,TEST_CHECK,HOLD_AUTH,CANCEL_AUTH,TEST_INPUT_AUTH,CHANGE_NODE_AUTH,
                CHANGE_ADDR_AUTH,RELEASE_AUTH,REINSTATE_AUTH,CHANGE_MEDIA_AUTH,BRANCH_MOVE_AUTH,CHANGE_PRIOR_AUTH,FT_UPLOAD,
                LINK_CONTRACT,MOVE_QUEUE,CHANGE_BRANCH_IN,CHANGE_ADDRESS_IN,AUTH_RIGHTS,CHANGE_MSG,CHANGE_MSG_AUTH)
        VALUES
                (u,'U','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y',
                'Y','Y','Y','Y','Y','Y','Y','Y','Y','Y');
END;

begin
       GLOBAL.PR_INIT(global.head_office,'SYSTEM');
pr('MARIOUEL','Elodie Mariou');
pr('JAQUESVI','Vincent Jaques');
pr('DARNANDCH','Christopher Darnand');
pr('LAUJA','Jacky Lau');
pr('HOACLY','Ly-Tign Hoac');
pr('SIOSONED','Eduardo Sioson');
pr('ATMADJAAD','Ady Atmadja');
pr('SEEJA','Jackson See');
end;
/


