declare
user_id varchar2(12):=upper('&user');

cursor cr_module IS
SELECT *
FROM	cstb_debug;

BEGIN
	FOR c1 IN cr_module
	LOOP
		insert into cstb_debug_users values(c1.module,c1.debug,user_id);
	END LOOP;
	COMMIT;
END;
/