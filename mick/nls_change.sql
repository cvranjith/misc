CREATE OR REPLACE PROCEDURE nls_change
( p_file_name IN varchar2)
AS

l_file_to_be_read utl_file.file_type;
l_file_to_be_writ utl_file.file_type;

l_read_buf VARCHAR2(2000);
l_writ_buf VARCHAR2(3000);

l_read_area VARCHAR2(20) := 'c:\nls\fc41';
l_writ_area VARCHAR2(20) := 'c:\nls\fc41wrt';
INVALID_PATH EXCEPTION;
INVALID_MODE EXCEPTION;
INVALID_FILEHANDLE EXCEPTION;
INVALID_OPERATION EXCEPTION;
READ_ERROR EXCEPTION;
WRITE_ERROR EXCEPTION;
INTERNAL_ERROR EXCEPTION;

BEGIN
BEGIN
DBMS_OUTPUT.PUT_LINE('filename = '||p_file_name);
l_file_to_be_read := utl_file.fopen(l_read_area,p_file_name,'r');
--DBMS_OUTPUT.PUT_LINE('after first open');

l_file_to_be_writ := utl_file.fopen(l_writ_area, p_file_name,'w');
--DBMS_OUTPUT.PUT_LINE('after second open');

EXCEPTION
WHEN INVALID_PATH
THEN dbms_output.put_line('INVALID_PATH');

WHEN INVALID_MODE
THEN dbms_output.put_line('INVALID_MODE');

WHEN INVALID_FILEHANDLE
THEN dbms_output.put_line('INVALID_FILEHANDLE');

WHEN INVALID_OPERATION
THEN dbms_output.put_line('INVALID_OPERATION');

WHEN READ_ERROR
THEN dbms_output.put_line('READ_ERROR');

WHEN WRITE_ERROR
THEN dbms_output.put_line('WRITE ERROR');

WHEN INTERNAL_ERROR
THEN dbms_output.put_line('INTERNAL_ERROR');

WHEN OTHERS
THEN dbms_output.put_line('here......'||SQLERRM);
END;
--dbms_output.put_line('after the exception handling.....');

LOOP
BEGIN
utl_file.get_line(l_file_to_be_read, l_read_buf);
--dbms_output.put_line('line read->'||l_read_buf);
IF INSTR (UPPER(l_read_buf), 'VARCHAR2(35)') > 0
THEN
l_writ_buf := lower(REPLACE (UPPER(l_read_buf),'VARCHAR2(35)','NLS_TABLE.DESCRIPTION_COLUMN%TYPE'));
-- l_writ_buf := REPLACE (UPPER(l_read_buf),'VARCHAR2(35)','nls_table.description_column%type');
-- dbms_output.put_line('varchar2 35 found');
--dbms_output.put_line('line read->'||l_read_buf);
--dbms_output.put_line('line read->'||l_writ_buf);

ELSE
l_writ_buf := l_read_buf;
END IF;

utl_file.put_line (l_file_to_be_writ, l_writ_buf);

EXCEPTION
WHEN NO_DATA_FOUND
THEN
utl_file.fclose(l_file_to_be_read);
utl_file.fclose(l_file_to_be_writ);
EXIT;

END;
END LOOP;
utl_file.fclose(l_file_to_be_read);
utl_file.fclose(l_file_to_be_writ);
dbms_output.put_line('success...'||SQLERRM);


EXCEPTION
WHEN OTHERS
THEN dbms_output.put_line('fataks...'||SQLERRM);
utl_file.fclose(l_file_to_be_read);
utl_file.fclose(l_file_to_be_writ);

END nls_change;
/