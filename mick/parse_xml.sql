declare
PROCEDURE parse_xml(p_xml_string IN VARCHAR2) IS
  l_doc XMLDOM.DOMDocument;
  l_node_list XMLDOM.DOMNodeList;
  l_node XMLDOM.DOMNode;
  l_tag_name VARCHAR2(400);
  l_value VARCHAR2(4000);
  function fn_get_xpath(n XMLDOM.DOMNode) return VARCHAR2
  is
    l_pth varchar2(4000);
    n1 XMLDOM.DOMNode;
    l_pth1 varchar2(4000);
    tb dbms_sql.varchar2_table;
  BEGIN
    n1 := n;
    for i in 1..100
    LOOP
        l_pth1 := XMLDOM.getNodeName(n1);
        if l_pth1 is null or l_pth1 = '#document' 
        then
            exit;
        end if;
        tb(tb.count+1):=l_pth1;
        n1 := XMLDOM.GETPARENTNODE(n1);
    end loop;
    if tb.count > 0
    then
        for i in reverse tb.first..tb.last
        loop
            l_pth := l_pth|| '/' || tb(i);
        end loop;
    end if;
    return l_pth;
  end;
BEGIN
  l_doc := XMLDOM.newDOMDocument(p_xml_string);
  l_node_list := XMLDOM.getElementsByTagName(l_doc, '*');
  FOR i IN 0..XMLDOM.getLength(l_node_list) - 1 LOOP
    l_node := XMLDOM.item(l_node_list, i);
    l_tag_name := XMLDOM.getNodeName(l_node);
    l_value := xmldom.getnodevalue(xmldom.getfirstchild(l_node));
    DBMS_OUTPUT.put_line(fn_get_xpath(l_node) || ' = ' || l_value);
  END LOOP;
END;
BEGIN
    parse_xml('<Document>
  <CstmrPmtStsRpt>
    <GrpHdr>
      <MsgId>C2BINDIAMESSAGID42022090002</MsgId>
      <CreDtTm>2022-11-03T10:36:44.374Z</CreDtTm>
      <InitgPty>
        <Nm>Initiating Party</Nm>
      </InitgPty>
    </GrpHdr>
    <OrgnlGrpInfAndSts>
      <OrgnlMsgId>C2BINDIAMESSAGID42022090002</OrgnlMsgId>
      <OrgnlMsgNmId>pain.001.001.09</OrgnlMsgNmId>
      <OrgnlCreDtTm>2022-07-01T09:59:59.999Z</OrgnlCreDtTm>
      <GrpSts>RJCT</GrpSts>
      <StsRsnInf>
        <Rsn>
          <Rsn>TRJT</Rsn>
        </Rsn>
        <AddtlInf>TechnicalRejection</AddtlInf>
      </StsRsnInf>
    </OrgnlGrpInfAndSts>
  </CstmrPmtStsRpt>
</Document>');
end;
/


