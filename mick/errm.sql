SELECT TYPE ||' '||ERR_CODE||' - '||MESSAGE FROM ERTB_MSGS
WHERE UPPER(ERR_CODE) LIKE UPPER(REPLACE('%&ERRCODE%',' ','%'))
/