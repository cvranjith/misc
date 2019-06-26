@proc

UPDATE SMTB_SMS_LOG
SET EXIT_FLAG = 1
WHERE EXIT_FLAG IS NULL
AND (USER_ID like ('SYSTEM%') or user_id like '&U%')
AND function_id <> 'SMSIGNON'
/

COMMIT;
