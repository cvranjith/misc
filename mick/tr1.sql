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
	x varchar2(100);
begin
	l_file := utl_file.Fopen(l_dir,l_filename,'r',10000);
	loop
	n := n+1;
	utl_file.GET_LINE(l_file,filebuf);
	l(n) := filebuf;
	if substr(filebuf,1,length('-- End of DDL script for')) = '-- End of DDL script for' then
		x := substr(filebuf,length('-- End of DDL script for'));
		l_file1 := utl_file.fopen(l_dir,x,'w',100000);
		for i in 1..n-1 loop
		        utl_file.put(l_file1, l(i));
		        utl_file.fflush(l_file1);
		end loop;
		utl_file.fclose(l_file1);
	end if;
end loop;

exception when no_data_found then
	for i in 1..n-1 loop
	dbms_output.put_line (l(i));
	end loop;
end;
/
