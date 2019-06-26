DECLARE

	l_cursor INTEGER;
	l_sql_stmt varchar2(1000);
	l_sequence_name varchar2(1000);
	l_return integer;
	
BEGIN
For c1 in (select branch_code from sttm_branch)
Loop
	FOR c2 in (SELECT process_code from cstb_process A
			WHERE  NOT EXISTS 
			(SELECT 'c' FROM USER_SEQUENCES
			WHERE SUBSTR(SEQUENCE_NAME,-4) = A.PROCESS_CODE
			AND SUBSTR(SEQUENCE_NAME,5,3) = c1.branch_code)
		) LOOP
        	l_sequence_name := 'TRSQ_'||c1.branch_code|| c2.process_code;
        	--l_sequence_name := 'RPSQ_SERVERADV';
		dbms_output.put_line('Creating Seq '||l_sequence_name);

        	l_cursor := DBMS_SQL.OPEN_CURSOR;

        	l_sql_stmt :='CREATE SEQUENCE ' || l_sequence_name ||
                ' INCREMENT BY 1 START WITH 1 MINVALUE 1 NOCYCLE NOCACHE
                NOORDER';

		BEGIN
	        	DBMS_SQL.PARSE (l_cursor ,l_sql_stmt ,DBMS_SQL.V7 ) ;
		EXCEPTION WHEN OTHERS THEN
			dbms_output.put_line(SQLERRM);
		END;	

        	DBMS_SQL.CLOSE_CURSOR(l_cursor);
	END LOOP;

End Loop;
	EXCEPTION

	WHEN OTHERS THEN
		dbms_output.put_line(SQLERRM);
END;
                        
