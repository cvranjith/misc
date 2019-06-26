select substr(sql_text,1,300) from v$sql a, v$session b
where a.address = b.sql_address
and a.osuser = '&osuser'
and username = '&username'
/
