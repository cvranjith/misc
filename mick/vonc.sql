SET VERIFY OFF
SET FEED OFF
select * from conv_commit where times like '%'||to_char(sysdate,'DD-MON-YYYY')||'%'
/
SELECT 'TRANSACTION TEMP - '||(select count(1) from acsts_transaction_temp_hbg)||'
FUND TEMP        - '||(select count(1) from acst_fund_temp_hbg) COUNT FROM DUAL
/
SET VERIFY ON
SET FEED ON
