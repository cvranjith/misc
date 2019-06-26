accept func_id PROMPT 'Enter the function id ==> '
accept func_desc PROMPT 'Enter the function description ==> '
select m.function_id, m.executable_name, m.module, f.main_menu, f.sub_menu_1, f.sub_menu_2
from smtb_menu m, smtb_function_description f
where m.function_id = f.function_id
and m.function_id like upper('%&FUNC_ID%')
and (upper(f.main_menu) like upper('%&FUNC_DESC%')
   or upper(f.sub_menu_1) like upper('%&FUNC_DESC%')
   or upper(f.sub_menu_2)  like upper('%&FUNC_DESC%')
)
order by m.function_id, f.main_menu, f.sub_menu_1, f.sub_menu_2
/
