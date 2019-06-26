SET TRIMSPOOL ON PAGES 0 LINE 9999 FEED OFF PAGES 0 LINE 9999

SPOOL SQ.TMP

select 'DROP SEQUENCE '||A.SEQUENCE_NAME||';'||'
CREATE SEQUENCE '||A.SEQUENCE_NAME||' START WITH '||A.LAST_NUMBER||' NOCACHE;'
from seq_back a,
user_sequences b
where a.sequence_name = b.sequence_name
and a.last_number <> b.last_number
/

SPOOL OFF 
SET FEED ON PAGES 100
--@SQ.TMP
