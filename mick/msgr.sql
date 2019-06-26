SET VERIFY OFF
UNDEFINE USERID
DELETE SMTB_MSGS_RIGHTS
WHERE USER_ROLE_ID = UPPER('&&USERID')
AND USER_ROLE_FLAG = 'U'
/

INSERT INTO SMTB_MSGS_RIGHTS
(USER_ROLE_ID,USER_ROLE_FLAG,GENERATE,HOLD,CANCEL,TEST_INPUT,CHANGE_NODE,CHANGE_ADDR,RELEASE,REINSTATE, 
CHANGE_MEDIA,CHANGE_PRIOR,BRANCH_MOVE,PRINT,TEST_CHECK,HOLD_AUTH,CANCEL_AUTH,TEST_INPUT_AUTH,CHANGE_NODE_AUTH, 
CHANGE_ADDR_AUTH,RELEASE_AUTH,REINSTATE_AUTH,CHANGE_MEDIA_AUTH,BRANCH_MOVE_AUTH,CHANGE_PRIOR_AUTH,FT_UPLOAD, 
LINK_CONTRACT,MOVE_QUEUE,CHANGE_BRANCH_IN,CHANGE_ADDRESS_IN,AUTH_RIGHTS,CHANGE_MSG,CHANGE_MSG_AUTH)
VALUES 
(UPPER('&&USERID'),'U','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y','Y',
'Y','Y','Y','Y','Y','Y','Y','Y','Y','Y')
/
COMMIT
/
UNDEFINE USERID
SET VERIFY ON