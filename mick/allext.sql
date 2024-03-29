@storeset
SET SERVEROUT ON SIZE 1000000 VERIFY OFF FEED OFF
PROMPT
PROMPT
DECLARE
	TOTAL_BLOCKS			NUMBER;
	TOTAL_BYTES			NUMBER;
	UNUSED_BLOCKS			NUMBER;
	UNUSED_BYTES			NUMBER;
	LAST_USED_EXTENT_FILE_ID	NUMBER;
	LAST_USED_EXTENT_BLOCK_ID	NUMBER;
	LAST_USED_BLOCK			NUMBER;
	SEGMENT_TYPE			VARCHAR2(1000);
	
BEGIN

	FOR I IN 
		(
		SELECT	SUM(BYTES/1024/1024) SUM_BYTES,
			SEGMENT_NAME,
			COUNT(1) EXTENTS_COUNT,
			tablespace_name,
			SEGMENT_TYPE,
			OWNER
		FROM 	DBA_EXTENTS
		WHERE 	SEGMENT_NAME = UPPER ('&SEGMENT')
		GROUP BY SEGMENT_NAME,tablespace_name,SEGMENT_TYPE,OWNER
		)
	LOOP
		dbms_space.unused_space
			(
			I.OWNER,
			I.SEGMENT_NAME,
			I.SEGMENT_TYPE,
			TOTAL_BLOCKS,
			TOTAL_BYTES,
			UNUSED_BLOCKS,
			UNUSED_BYTES,
			LAST_USED_EXTENT_FILE_ID,
			LAST_USED_EXTENT_BLOCK_ID,
			LAST_USED_BLOCK
			);
		DBMS_OUTPUT.PUT_LINE('************************************************');
		DBMS_OUTPUT.PUT_LINE('Segment              '||I.SEGMENT_NAME);
		DBMS_OUTPUT.PUT_LINE('Tablespace           '||I.TABLESPACE_NAME);
		DBMS_OUTPUT.PUT_LINE('Count of Extents     '||I.EXTENTS_COUNT);
		DBMS_OUTPUT.PUT_LINE('Total Bytes          '||TOTAL_BYTES||'  ['||ROUND(TOTAL_BYTES/1024/1024)||'M]');
		DBMS_OUTPUT.PUT_LINE('Unused Bytes         '||UNUSED_BYTES||'  ['||ROUND(UNUSED_BYTES/1024/1024)||'M]');
		DBMS_OUTPUT.PUT_LINE('Total Blocks         '||TOTAL_BLOCKS);
		DBMS_OUTPUT.PUT_LINE('Unused Blocks        '||UNUSED_BLOCKS);
		DBMS_OUTPUT.PUT_LINE('************************************************');
	END LOOP;
END;
/
PROMPT
PROMPT
@resetoreset
