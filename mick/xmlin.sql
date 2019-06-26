SET SERVEROUT ON SIZE 1000000

DECLARE
p_xmlmsg LONG;
p_source VARCHAR2(2000);
p_rectype VARCHAR2(2000);
p_key LONG;
p_data LONG;
p_xmlrootname VARCHAR2(2000);
p_xmlinfo VARCHAR2(2000);
p_dtdorxsd VARCHAR2(2000);
p_media VARCHAR2(2000);
p_mediainfo VARCHAR2(2000);
p_emptytags VARCHAR2(2000);
p_clob_flag VARCHAR2(2000);
p_clob_key CLOB;
p_clob_data CLOB;
p_xlsname VARCHAR2(2000);
p_batchflg VARCHAR2(2000);
p_hdr_rectype VARCHAR2(2000);
p_hdr_key LONG;
p_hdr_data LONG;
p_hdr_xmlinfo VARCHAR2(2000);
p_xml_ascii VARCHAR2(2000);
p_encrypt_reqd VARCHAR2(2000);
p_encrypt_algo VARCHAR2(2000);
p_msgid VARCHAR2(2000);
p_flag NUMBER;
p_err VARCHAR2(2000);
p_prms VARCHAR2(2000);
BEGIN
  p_xmlmsg := 'ID:414d5120514d5f495053563120202020e3b6ba41219f3c06^1336958492^<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE FCCMSG SYSTEM "FccMsg.dtd"><FCCMSG>
<UPLOAD_SWIFT_MSG>
        <SCODE>FCMERVA</SCODE>
<XREF>SWSP050217145425</XREF>
<BRN>804</BRN>
<MAKERID/>
<MEDIA>SWIFT</MEDIA>
<SWIFT_MSG_TYPE>MT202</SWIFT_MSG_TYPE>
<MCS>SWIFT</MCS>
<MESSAGE>ezE6RjAxREJTU1RXVDBBWFhYMDEyNTAwMDcyOH17MjpPMjAyMTA1ODA1MDIxN0RCU1NUV1QwQVhYWDAxMjUwMDA1NDAwNTAyMTcxMDU4Tn17NDoNCjoyMDpTMjAyLUNLQy0xNzAyMDUNCjoyMTpTMjAyLVRFU1RJTkctQ0tDDQo6MzJBOjA1MDIxN1VTRDEwMDAsDQo6NThBOkRCU1NVUzZMDQotfXs1OntNQUM6MzZGMTFFMzF9e0NISzpDQjYzQzAzMzlFMER9e1RORzp9fQ==</MESSAGE>
    </UPLOAD_SWIFT_MSG>
</FCCMSG>';
  p_source := 'FCMERVA';
  p_rectype := 'UPLOAD_SWIFT_MSG';
  p_key := 'SCODE~XREF~BRN~MAKERID~MEDIA~SWIFT_MSG_TYPE~MCS~MESSAGE~';
  p_data := 'FCMERVA~SWSP050217145425~804~~SWIFT~MT202~SWIFT~ezE6RjAxREJTU1RXVDBBWFhYMDEyNTAwMDcyOH17MjpPMjAyMTA1ODA1MDIxN0RCU1NUV1QwQVhYWDAxMjUwMDA1NDAwNTAyMTcxMDU4Tn17NDoNCjoyMDpTMjAyLUNLQy0xNzAyMDUNCjoyMTpTMjAyLVRFU1RJTkctQ0tDDQo6MzJBOjA1MDIxN1VTRDEwMDAsDQo6NThBOkRCU1NVUzZMDQotfXs1OntNQUM6MzZGMTFFMzF9e0NISzpDQjYzQzAzMzlFMER9e1RORzp9fQ==~';
  p_xmlrootname := 'FCCMSG';
  p_dtdorxsd := 'DTD';
  p_media := 'Q';
  p_mediainfo := 'UIST.ONLINE.GET.DOCFWD.ATTACHADD.3005.SV.GTP';
  p_clob_flag := 'N';
-- p_clob_key - parameter data type CLOB not supported
-- p_clob_data - parameter data type CLOB not supported
  p_batchflg := 'N';
  p_hdr_rectype := '';
  p_hdr_key := '';
  p_hdr_data := '';
  p_xml_ascii := 'X';
  p_encrypt_reqd := '';
  p_encrypt_algo := '';
  p_msgid := '';
  p_flag := NULL;
  p_err := '';
  p_prms := '';

-- Now call the stored program
  ifpks_xml_proc.pr_xmlin(p_xmlmsg,p_source,p_rectype,p_key,p_data,p_xmlrootname,p_xmlinfo,p_dtdorxsd,'N',p_media,p_mediainfo,p_emptytags,p_clob_flag,p_clob_key,p_clob_data,p_xlsname,p_batchflg,p_hdr_rectype,p_hdr_key,p_hdr_data,p_hdr_xmlinfo,p_xml_ascii,p_encrypt_reqd,p_encrypt_algo,p_msgid,p_flag,p_err,p_prms);

-- Output the results
  dbms_output.put_line(SubStr('p_xmlmsg = '||p_xmlmsg,1,255));
  dbms_output.put_line(SubStr('p_source = '||p_source,1,255));
  dbms_output.put_line(SubStr('p_rectype = '||p_rectype,1,255));
  dbms_output.put_line(SubStr('p_key = '||p_key,1,255));
  dbms_output.put_line(SubStr('p_data = '||p_data,1,255));
  dbms_output.put_line(SubStr('p_xmlrootname = '||p_xmlrootname,1,255));
  dbms_output.put_line(SubStr('p_xmlinfo = '||p_xmlinfo,1,255));
  dbms_output.put_line(SubStr('p_dtdorxsd = '||p_dtdorxsd,1,255));
  dbms_output.put_line(SubStr('p_media = '||p_media,1,255));
  dbms_output.put_line(SubStr('p_mediainfo = '||p_mediainfo,1,255));
  dbms_output.put_line(SubStr('p_emptytags = '||p_emptytags,1,255));
  dbms_output.put_line(SubStr('p_clob_flag = '||p_clob_flag,1,255));
  dbms_output.put_line(SubStr('p_xlsname = '||p_xlsname,1,255));
  dbms_output.put_line(SubStr('p_batchflg = '||p_batchflg,1,255));
  dbms_output.put_line(SubStr('p_hdr_rectype = '||p_hdr_rectype,1,255));
  dbms_output.put_line(SubStr('p_hdr_key = '||p_hdr_key,1,255));
  dbms_output.put_line(SubStr('p_hdr_data = '||p_hdr_data,1,255));
  dbms_output.put_line(SubStr('p_hdr_xmlinfo = '||p_hdr_xmlinfo,1,255));
  dbms_output.put_line(SubStr('p_xml_ascii = '||p_xml_ascii,1,255));
  dbms_output.put_line(SubStr('p_encrypt_reqd = '||p_encrypt_reqd,1,255));
  dbms_output.put_line(SubStr('p_encrypt_algo = '||p_encrypt_algo,1,255));
  dbms_output.put_line(SubStr('p_msgid = '||p_msgid,1,255));
  dbms_output.put_line('p_flag = '||TO_CHAR(p_flag));
  dbms_output.put_line(SubStr('p_err = '||p_err,1,255));
  dbms_output.put_line(SubStr('p_prms = '||p_prms,1,255));

EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line('Error '||TO_CHAR(SQLCODE)||': '||SQLERRM);
RAISE;
END;
/
