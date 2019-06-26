col menu form a100
select '['||function_id||'] '||main_menu||decode(sub_menu_1,null,null,' --> ')||sub_menu_1||decode(sub_menu_2,null,null,' --> ')||sub_menu_2 menu
from smtb_function_description
where upper(function_id||main_menu||sub_menu_1||sub_menU_2) like replace(UPPER('%&STRING%'),' ','%')
and lang_code = 'ENG'
/
