col owner form a20
col directory_name form a30
col directory_path form a50
select *from all_directories
where directory_name like '%&dir%'
/
