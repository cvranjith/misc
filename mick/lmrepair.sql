BEGIN
FOR I IN
(
select LIAB_BR,ROWID RID
from lmtm_liab a
where util_amt <> (select sum(liab_util) from lmtb_line_utils where liab_id = a.liab_id and track_cust_exp='Y') 
) LOOP
IF NVL(GLOBAL.CURRENT_BRANCH,'!!!')<> I.LIAB_BR
THEN
    GLOBAL.PR_INIT(I.LIAB_BR,'SYSTEM');
END IF;
UPDATE LMTM_LIAB SET LIMIT_CCY = LIMIT_CCY WHERE ROWID = I.RID;
END LOOP;
END;
/
