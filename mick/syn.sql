SELECT SYNONYM_NAME, TABLE_NAME FROM USER_SYNONYMS
WHERE TABLE_NAME LIKE UPPER(REPLACE('%&TAB%',' ','%'))
/