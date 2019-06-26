declare
	TYPE tbls IS TABLE OF VARCHAR2(1500) INDEX BY BINARY_INTEGER;
	l tbls;
	l_file     utl_file.file_type;
	filebuf   varchar2(3000);
	l_dir   varchar2(2000) := 'f:\cv\issues';
	l_filename varchar2(2000) := 'xx.txt';--'ALL_TRIGGERS.sql'; --'betaissues.txt';
	n number := 0;
	p number := 0;
	l_file1     utl_file.file_type;
begin
	l_file := utl_file.Fopen(l_dir,l_filename,'r',10000);
	loop
		utl_file.GET_LINE(l_file,filebuf);
		l_file1 := utl_file.Fopen(l_dir,'SEEVI.TXT','w',10000);
		dbms_output.put_line ('rem '||filebuf);
	begin
		utl_file.PUT(l_file1,filebuf);
		dbms_output.put_line('dr 1');
	        utl_file.fflush(l_file1);
		dbms_output.put_line('dr 2');
	exception when others then
		dbms_output.put_line('dr '||sqlerrm);
	end;
/*		dbms_output.put_line ('rem '||filebuf);
		if substr(filebuf,1,length('-- Start of DDL script for ')) = '-- Start of DDL script for '
		then
		dbms_output.put_line ('spool '||substr(filebuf,length('-- Start of DDL script for '))||'.trg');
		end if;*/
	end loop;
      utl_file.fclose(L_FILE1);
exception when others then
	dbms_output.put_line('!! '||sqlerrm);
end;
/
