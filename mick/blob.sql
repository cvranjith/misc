declare
    l_blob    blob;
    l_bfile    bfile;
begin
    insert into rptb_stmt_docs values ( '0000006','200801', '01-JAN-2008','31-JAN-2008', empty_blob() ) 
    returning stmt_doc into l_blob;
    l_bfile := bfilename( 'WORK_AREA', 'STMNT.0000006.912.20080131.pdf' );
    dbms_lob.fileopen( l_bfile );
    dbms_lob.loadfromfile( l_blob, l_bfile,dbms_lob.getlength( l_bfile ) );
    dbms_lob.fileclose( l_bfile );
end;
/
