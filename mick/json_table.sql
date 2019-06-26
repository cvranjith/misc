with t as (select 'abcd~efgh~123~abcdeef' c from dual) 
select n
  from t
     , json_table('["'||replace(t.c,'~','","')||'"]', '$[*]' columns n varchar2 path '$') j
/
