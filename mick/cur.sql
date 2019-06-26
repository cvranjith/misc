INSERT INTO SMTB_CURRENT_USERS
(
USER_ID                         ,
TERMINAL                        ,
START_TIME                      ,
HOME_BRANCH                     ,
CURRENT_BRANCH                  
)
VALUES
(
'&USER',
TO_CHAR(SYSDATE,'MISS'),
SYSDATE,
GLOBAL.HEAD_OFFICE,
'&BR'
)
/
