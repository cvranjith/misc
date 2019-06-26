DECLARE
	l_file		UTL_FILE.file_type;
	filebuf		LONG;--varchar2(3000);
	l_dir		VARCHAR2(2000) := 'f:\cv\issues';
	l_filename	VARCHAR2(2000) := 'PLErrors1.txt'; --'betaissues.txt';
	n			NUMBER := 0;
	p			NUMBER := 0;
	tberr		OERR%ROWTYPE;
BEGIN
	DELETE OERR;
	l_file := UTL_FILE.fopen(l_dir,l_filename,'r',32767);
	LOOP
		n := n+1;
		p := p+1;
		UTL_FILE.get_line(l_file,filebuf);
		IF SUBSTR(filebuf,1,length('<ID>')) = '<ID>'
		THEN
			p := 0;
		END IF;
		IF p = 1
		THEN
			tberr.err := filebuf;
		ELSIF p = 3
		THEN
			tberr.msg := filebuf;
		ELSIF p = 5
		THEN
			tberr.cause := filebuf;
		ELSIF p = 7
		THEN
			tberr.action := filebuf;
			INSERT INTO OERR
				(
				err,
				msg,
				cause,
				action
				)
			VALUES
				(
				tberr.err,
				tberr.msg,
				tberr.cause,
				tberr.action
				);
		ELSE
			NULL;
		END IF;
	END LOOP;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
			UPDATE	OERR
			SET		cause = SUBSTR(cause,8),
					action = SUBSTR(action,9);
	WHEN OTHERS
	THEN
		DBMS_OUTPUT.put_line('!! '||n||' '||p||SQLERRM);
END;
/
