set serverout on size 100000
DECLARE
p_function VARCHAR2(2000);
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
p_msglabel VARCHAR2(2000);
p_handoff_no VARCHAR2(2000);
p_handoffdt VARCHAR2(2000);
p_clob_flag VARCHAR2(2000);
p_clob_key CLOB;
p_clob_data CLOB;
p_xlsname VARCHAR2(2000);
p_hdr_rectype VARCHAR2(2000);
p_hdr_key LONG;
p_hdr_data LONG;
p_hdr_xmlinfo VARCHAR2(2000);
p_xml_ascii VARCHAR2(2000);
p_encrypt_reqd VARCHAR2(2000);
p_encrypt_algo VARCHAR2(2000);
p_priority NUMBER;
p_no_of_retries VARCHAR2(2000);
p_session_timeout VARCHAR2(2000);
p_resend VARCHAR2(2000);
p_flag NUMBER;
p_err VARCHAR2(2000);
p_prms VARCHAR2(2000);
p_alter_media_req VARCHAR2(2000);
p_alter_media VARCHAR2(2000);
p_alter_mediainfo VARCHAR2(2000);
p_alter_mediainfo_wip VARCHAR2(2000);
BEGIN
  p_function := 'MS';
  p_source := '';
  p_rectype := '';
  p_key := '';
  p_data := '';
  p_xmlrootname := '';
  p_dtdorxsd := '';
  p_media := '';
  p_mediainfo := '';
  p_handoff_no := '';
  p_handoffdt := '';
  p_clob_flag := '';
-- p_clob_key - parameter data type CLOB not supported
-- p_clob_data - parameter data type CLOB not supported
  p_hdr_rectype := '';
  p_hdr_key := '';
  p_hdr_data := '';
  p_xml_ascii := 'X';
  p_encrypt_reqd := '';
  p_encrypt_algo := '';
  p_priority := NULL;
  p_no_of_retries := '';
  p_session_timeout := '';
  p_resend := '';
  p_flag := NULL;
  p_err := '';
  p_prms := '';

-- Now call the stored program
  FLEXMLS.ifpks_xml_proc.pr_xmlout('804',p_function,'&COD_IDENTIFIER',p_source,p_rectype,p_key,p_data,p_xmlrootname,p_xmlinfo,p_dtdorxsd,p_media,p_mediainfo,p_emptytags,p_msglabel,'AAAE3VAADAAAYBVAAR',p_handoff_no,p_handoffdt,p_clob_flag,p_clob_key,p_clob_data,p_xlsname,p_hdr_rectype,p_hdr_key,p_hdr_data,p_hdr_xmlinfo,p_xml_ascii,p_encrypt_reqd,p_encrypt_algo,p_priority,p_no_of_retries,p_session_timeout,p_resend,p_flag,p_err,p_prms,p_alter_media_req,p_alter_media,p_alter_mediainfo,p_alter_mediainfo_wip);

-- Output the results
  dbms_output.put_line(SubStr('p_function = '||p_function,1,255));
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
  dbms_output.put_line(SubStr('p_msglabel = '||p_msglabel,1,255));
  dbms_output.put_line(SubStr('p_handoff_no = '||p_handoff_no,1,255));
  dbms_output.put_line(SubStr('p_handoffdt = '||p_handoffdt,1,255));
  dbms_output.put_line(SubStr('p_clob_flag = '||p_clob_flag,1,255));
  dbms_output.put_line(SubStr('p_xlsname = '||p_xlsname,1,255));
  dbms_output.put_line(SubStr('p_hdr_rectype = '||p_hdr_rectype,1,255));
  dbms_output.put_line(SubStr('p_hdr_key = '||p_hdr_key,1,255));
  dbms_output.put_line(SubStr('p_hdr_data = '||p_hdr_data,1,255));
  dbms_output.put_line(SubStr('p_hdr_xmlinfo = '||p_hdr_xmlinfo,1,255));
  dbms_output.put_line(SubStr('p_xml_ascii = '||p_xml_ascii,1,255));
  dbms_output.put_line(SubStr('p_encrypt_reqd = '||p_encrypt_reqd,1,255));
  dbms_output.put_line(SubStr('p_encrypt_algo = '||p_encrypt_algo,1,255));
  dbms_output.put_line('p_priority = '||TO_CHAR(p_priority));
  dbms_output.put_line(SubStr('p_no_of_retries = '||p_no_of_retries,1,255));
  dbms_output.put_line(SubStr('p_session_timeout = '||p_session_timeout,1,255));
  dbms_output.put_line(SubStr('p_resend = '||p_resend,1,255));
  dbms_output.put_line('p_flag = '||TO_CHAR(p_flag));
  dbms_output.put_line(SubStr('p_err = '||p_err,1,255));
  dbms_output.put_line(SubStr('p_prms = '||p_prms,1,255));
  dbms_output.put_line(SubStr('p_alter_media_req = '||p_alter_media_req,1,255));
  dbms_output.put_line(SubStr('p_alter_media = '||p_alter_media,1,255));
  dbms_output.put_line(SubStr('p_alter_mediainfo = '||p_alter_mediainfo,1,255));
  dbms_output.put_line(SubStr('p_alter_mediainfo_wip = '||p_alter_mediainfo_wip,1,255));

EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line('Error '||TO_CHAR(SQLCODE)||': '||SQLERRM);
RAISE;
END;
/
