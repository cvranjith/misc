SET LONG 9999
SET LINE 9999
SET PAGES 0
--SET HEAD OFF
select text from user_views where view_name = UPPER('&VIEW')
/
