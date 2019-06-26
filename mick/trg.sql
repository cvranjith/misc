declare
	l_file		UTL_FILE.file_type;
	filebuf		LONG;
	l_dir		VARCHAR2(2000);
	l_filename1	VARCHAR2(2000);
	l_filename2	VARCHAR2(2000);
	tb_v		smpks_signon.tbl_varchar2;
BEGIN
	l_dir := 'F:\CV\IFACE\DBSCRIPTS';
	l_filename1 := 'TRIGGERS.sql';
	pr_read_text_file(l_dir,l_filename1,tb_v);
	L_DIR := 'F:\CV\IFACE\DBSCRIPTS\TRIGGER';
	FOR N IN TB_V.FIRST .. TB_V.LAST
	LOOP
		filebuf := TB_V(N);
		IF SUBSTR(FILEBUF,1,11) = '-- Trigger ' THEN
			l_filename2 := SUBSTR(FILEBUF,12)||'.SQL';
			--DBMS_OUTPUT.PUT_LINE('OPENING .. '||l_filename2);
			l_file := UTL_FILE.fopen(l_dir,l_filename2,'w',32767);
			--DBMS_OUTPUT.PUT_LINE('OPENED');
			END IF;
		IF SUBSTR(FILEBUF,1,25) = '-- End of DDL script for ' THEN
			UTL_FILE.fclose(l_file);
		END IF;
		IF (	SUBSTR(FILEBUF,1,27) = '-- Start of DDL script for '
		   OR	SUBSTR(FILEBUF,1,24) = '-- Generated 15-jan-02  '
		   OR	FILEBUF = '-- from fcisuat-FCCLIVE:1'
		   OR	NVL(FILEBUF,'#$') = '#$'
		   OR   SUBSTR(FILEBUF,1,25) = '-- End of DDL script for '
		   )
		THEN
			NULL;
		ELSE
			--DBMS_OUTPUT.PUT_LINE(filebuf);
			UTL_FILE.put_line(l_file,filebuf);
		END IF;
	END LOOP;
	UTL_FILE.fclose(l_file);
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
		UTL_FILE.fclose(l_file);
		RETURN;
	WHEN OTHERS THEN
		UTL_FILE.fclose(l_file);
		DBMS_OUTPUT.put_line('!! '||SQLERRM);
END;
/
