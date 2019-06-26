declare
	psource	VARCHAR2(20) := '';
	pRectype	varchar2(1000):='UPLOAD_PMNT>STTLMNT';
	pKey		varchar2(1000):='SCODE~XREF~BRN~PRD~DRBRN~DRACC~DRCCY~DRAMT~DRVALDT~CRBRN~CRACC~CRCCY~CRAMT~CRVALDT~MSG_COVER~XRATE~CHG_WHOM~UPLD_MSG_TYPE~TDESC~AUTHSTAT~>BY_ORD_OF1~ULT_BEN1~ULT_BEN2~ULT_BEN3~ULT_BEN4~ACC_WITH_INST1~ACC_WITH_INST2~ACC_WITH_INST3~ACC_WITH_INST4~INTRMD1~SNDR_RECVR_INFO1~SNDR_RECVR_INFO2~SNDR_RECVR_INFO3~SNDR_RECVR_INFO4~SNDR_RECVR_INFO5~SNDR_RECVR_INFO6~ORD_INST1~ORD_INST2~ORD_INST3~ORD_INST4~ORD_INST5~INT_REIM_INST1~RECVR~';
	pData		varchar2(1000):='FOREST~JP00032XJ0000009~001~001000000004TT~001~000000004~JPY~999999900~2002/11/19~001~001PEN~PEN~111111~2002/11/19~001PEN~~0~001~Request date = 2002/11/19~A~>Tomohiro Mori~mojamojamojamoja mojamoajjajmojaja~addressaddressaddressaddressaddress~addressaddressaddressaddressaddress~addressaddressaddressaddressaddress~CITINYUS~~~~001PEN~/HOLD/11111111111111111111111111111111111~/PHON/000000000000000~001~~~~000000004~~~~~001PEN~001PEN~';

	pidentifier	VARCHAR2(2000);
	pflag		number; 
	perr		varchar2(100):='';
	pprms		varchar2(1000):='';

	p_xmlmsg	VARCHAR2(2000);
	p_xmlinfo	VARCHAR2(2000);
	p_xmlrootname	VARCHAR2(2000);
	p_dtdorxsd	VARCHAR2(2000);
	p_qname	VARCHAR2(2000);
	p_emptytags	VARCHAR2(2000);
begin
	ifpks_xml_proc.pr_xmlin
	(	p_xmlmsg
	,	psource
	,	pRectype
	,	pkey
	,	pdata
	,	p_xmlrootname
	,	p_xmlinfo
	,	p_dtdorxsd
	,	'N'
	,	p_qname
	,	p_emptytags
	,	pflag
	,	perr
	,	pprms
	);


/*
	IF pflag <> 0
	THEN
		ROLLBACK;
	ELSE
		COMMIT;
	END IF;
*/
	debug.pr_close;

	dbms_output.put_line('p_xmlmsg:'||p_xmlmsg);
	dbms_output.put_line('psource:'||psource);
	dbms_output.put_line('pRectype:'||pRectype);
--	dbms_output.put_line('pkey:'||pkey);
--	dbms_output.put_line('pdata:'||pdata);
	dbms_output.put_line('p_xmlrootname:'||p_xmlrootname);
	dbms_output.put_line('p_dtdorxsd:'||p_dtdorxsd);
	dbms_output.put_line('p_qname:'||p_qname);
	dbms_output.put_line('p_emptytags:'||p_emptytags);

	dbms_output.put_line('pflag:' || pflag);
	dbms_output.put_line('pErr:' || pErr);
	dbms_output.put_line('pprms:' || pprms);

end;
/

