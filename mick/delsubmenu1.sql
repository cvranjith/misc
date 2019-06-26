delete from smtb_role_detail
where role_function in
(select function_id from smtb_function_description where sub_menu_1 = '&Submenu1')
/