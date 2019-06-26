undef tname

SELECT table_name,TRIGGER_NAME
FROM USER_TRIGGERS t
WHERE TABLE_NAME like REPLACE(upper('%&&TNAME%'),' ','%')
--or exists (select table_name from user_synonyms s where synonym_name like REPLACE(upper('%&&TNAME%'),' ','%') and s.table_name = t.table_name)
/

undef tname
