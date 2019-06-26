set pages 0 line 9999 trimspo on
spo TMP.TMP
SELECT 'DROP TABLE FLXOLAB.'||TABLE_NAME||' ;' from user_tables;
spo off
