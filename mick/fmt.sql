@storeset
SET TRIMSPO ON PAGES 0 LINE 999 FEED OFF
SPO TMP.TMP
SELECT DISTINCT 'SPO D:\TEMP\FMT\'||FORMAT||'.TXT'||CHR(10)||
'SELECT FORMAT_LINE FROM MSTM_ADV_FORMAT_DET WHERE FORMAT = '||
CHR(39)||FORMAT||CHR(39)||' ORDER BY LINE_NUMBER ;'||CHR(10)||
'SPO OFF'
FROM MSTM_ADV_FORMAT_DET
/

@TMP.TMP
@restoreset
