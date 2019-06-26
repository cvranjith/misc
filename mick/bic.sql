/*
 __________________________________________________________________________________________________________________
|                                                                                                                  |
|                                                                                                                  |
|                                  INSTRUNCTIONS FOR BIC UPLOAD USING THIS SCRIPT                                  |
|                                                                                                                  |
|__________________________________________________________________________________________________________________|


*   THIS SCRIPT HAS BEEN GIVEN FOR UPLOADING THE BIC CODES INTO FLEXCUBE'S TABLE (ISTM_BIC_DIRECTORY)
    FROM THE FLAT FILE FI.DAT GOTTEN FROM SWIFT ALLIANCE.

*   THIS SCRIPT HAS BEEN CREATED REFERRING TO THE FI.DAT FILE PROVIDED BY IVB DURING IMPLEMENTATION.
    IF ANY CHANGE IN THE STRUCTURE OF FI.DAT, THEN THE SCRIPT WOULD NEED TO BE MODIFIED.

*   TABLES TMP_BIC AND ISTM_BIC_DIRECTORY_BACK NEEDS TO BE CREATED (IF THEY WERE NOT CREATED ALREADY) FOR RUNNING THIS SCRIPT
    TABLE TMP_BIC IS A TEMPORARY TABLE USED FOR THE PURPOSE OF STORING THE VALUE OF FI.DAT.
    TABLE ISTM_BIC_DIRECTORY_BACK IS CREATED FOR TAKING A BACKUP OF THE EXISTING TABLE ISTM_BIC_DIRECTORY.
    THIS BACKUP TABLE CAN BE USED FOR RESTORING THE BIC_DIRECTORY IN CASE ITS REQUUIRED.
    FOR CREATING THE TABLES, PLS RUN THE CREATE TABLE SCRIPTS.

*   THE FILE FI.dat IS ASSUMED TO BE STORED IN /tmp OF THE DATABASE SERVER. IF THE PATH OR FILE NAME IS|ARE DIFFERENT
    PLS CHANGE THE LINE IN THE SCRIPT THAT USES "utl_file.fopen"


*/



/*
---------------------------------------------------------------------------------------------------------------
-- Run the following create table scripts if the tables tmp_bic and istm_bic_directory_back are not present
---------------------------------------------------------------------------------------------------------------

create table tmp_bic
(
col1 varchar2(100),
col2 varchar2(100),
col3 varchar2(100),
col4 varchar2(100),
col5 varchar2(100),
col6 varchar2(100),
col7 varchar2(100),
col8 varchar2(100),
col9 varchar2(100),
col10 varchar2(100),
col11 varchar2(100),
col12 varchar2(100),
col13 varchar2(100),
col14 varchar2(100),
col15 varchar2(100)
)
/
create table istm_bic_directory_back as select a.*,sysdate backup_date from istm_bic_directory a where rownum = 0
/

*/



DECLARE
	f 		UTL_FILE.file_type;
	l 		VARCHAR2(30000);
	l_rec		tmp_bic%ROWTYPE;
	split		DBMS_SQL.number_table;
	val		VARCHAR2(4500);
	s		NUMBER;
	e		NUMBER;
BEGIN
	
	---------------------------------------------------------------------------------
	-- Pls look at some sample lines in the file (FI.Dat)
	-- The following lines are to split the line to fields. If the position is changing,
	-- you may need to change the below accordingly.
	---------------------------------------------------------------------------------
	
	split( split.COUNT + 1 ) := 4;
	split( split.COUNT + 1 ) := 15;
	split( split.COUNT + 1 ) := 120;
	split( split.COUNT + 1 ) := 190;
	split( split.COUNT + 1 ) := 225;
	split( split.COUNT + 1 ) := 289;
	split( split.COUNT + 1 ) := 324;
	split( split.COUNT + 1 ) := 359;
	split( split.COUNT + 1 ) := 394;
	split( split.COUNT + 1 ) := 464;
	split( split.COUNT + 1 ) := 569;
	split( split.COUNT + 1 ) := 639;
	split( split.COUNT + 1 ) := 674;
	split( split.COUNT + 1 ) := 779;
	delete tmp_bic;
	commit;
	
	-------------------------------------------------------------------------------------------------
	-- If the file name or Path are different, the following line needs to be edited accordingly
	-------------------------------------------------------------------------------------------------
	
	f := utl_file.fopen('/tmp','FI.dat','r',32767);
	BEGIN
		LOOP
			utl_file.get_line(f,l);
			l_rec := NULL;
			FOR i IN split.FIRST .. split.LAST
			LOOP
				IF i = split.FIRST
				THEN
					s := 1;
				ELSE
					s := split(i-1);
				END IF;
				IF i = split.LAST
				THEN
					e := 500;
				ELSE
					e := split(i)-1;
				END IF;
				val := SUBSTR(l,s,(e-s+1));
				val := LTRIM(RTRIM(val));
				--dbms_output.put_line(i||' - '||s||' - '||e);
				IF i = 1	THEN	l_rec.col1  := val;
				--dbms_output.put_line(val);
				ELSIF i=2	THEN	l_rec.col2  := val;
				ELSIF i=3	THEN	l_rec.col3  := val;
				ELSIF i=4	THEN	l_rec.col4  := val;
				ELSIF i=5	THEN	l_rec.col5  := val;
				ELSIF i=6	THEN	l_rec.col6  := val;
				ELSIF i=7	THEN	l_rec.col7  := val;
				ELSIF i=8	THEN	l_rec.col8  := val;
				ELSIF i=9	THEN	l_rec.col9  := val;
				ELSIF i=10	THEN	l_rec.col10 := val;
				ELSIF i=11	THEN	l_rec.col11 := val;
				ELSIF i=12	THEN	l_rec.col12 := val;
				ELSIF i=13	THEN	l_rec.col13 := val;
				ELSIF i=14	THEN	l_rec.col14 := val;
				ELSIF i=15	THEN	l_rec.col15 := val;
				END IF;
			END LOOP;
			INSERT INTO tmp_bic VALUES l_rec;
			commit;
			--exit;
		END LOOP;
	EXCEPTION
		WHEN NO_DATA_FOUND
		THEN
			NULL;
	END;
	utl_file.fclose(f);
EXCEPTION
	WHEN OTHERS
	THEN
		DBMS_OUTPUT.put_line('Error '||SQLERRM);
		IF utl_file.is_open(f)
		THEN
			utl_file.fclose(f);
		END IF;
END;
/
insert into istm_bic_directory_back select a.*,sysdate from istm_bic_directory a;
commit;

BEGIN
	for i IN (
		SELECT	rowid rid, 
			bic_code
		FROM 	istm_bic_directory
		where 	record_stat = 'O'
		and 	nvl(UPLOAD_UPDATE,'N') ='Y'
		)
	loop
		for j IN
			(
			select substr(col3,1,35) bank_name,
			substr(col4,1,35) bank_addr1,
			substr(col5,1,35) bank_addr2,
			substr(col8||' '||col9,1,35) bank_addr3
			from tmp_bic
			where col2 = i.bic_code
			)
		loop
			update	istm_bic_directory
			set	bank_name = j.bank_name,
				bank_address1 = j.bank_addr1,
				bank_address2 = j.bank_addr2,
				bank_address3 = j.bank_addr3,
				mod_no = mod_no+1,
				maker_id = 'UPLOAD',
				checker_id= 'UPLOAD',
				maker_dt_stamp = sysdate,
				checker_dt_stamp = sysdate
			WHERE	rowid = i.rid;
			commit;
		end loop;
	end loop;
END;
/

insert into istm_bic_directory
	(
	BIC_CODE,
	BANK_NAME,
	CUSTOMER_NO,
	SK_ARRANGEMENT,
	MOD_NO,
	RECORD_STAT,
	MAKER_ID,
	MAKER_DT_STAMP,
	CHECKER_ID,
	CHECKER_DT_STAMP,
	ONCE_AUTH,
	AUTH_STAT,
	BANK_ADDRESS1,
	BANK_ADDRESS2,
	BANK_ADDRESS3,
	RELATIONSHIP,
	SWIFT_KEY,
	TELEX_KEY,
	UPLOAD_FLAG,
	UPLOAD_UPDATE,
	GEN_MT103,
	BLACKLISTED,
	CUG_MEMBER,
	LVP_INDICATOR,
	ISO15022,
	GEN_MT103P,
	MULTI_CUST_TRANSFER,
	MAX_SIZE
	)
select	col2,
	substr(col3,1,35),
	null,
	'N',
	1,
	'O',
	'UPLOAD',
	sysdate,
	'UPLOAD',
	sysdate,
	'Y',
	'A',
	substr(col4,1,35),
	substr(col5,1,35),substr(col8||' '||col9,1,35),
	'N',
	null,
	null,
	'Y',
	'Y',
	'Y',
	'N',
	'N',
	'N',
	'N',
	'N',
	'N',
	null
from	tmp_bic
where 	not exists (select 1 from istm_bic_directory where bic_code = col2)
/

commit;


