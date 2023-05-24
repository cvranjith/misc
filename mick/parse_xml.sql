declare
PROCEDURE parse_xml(p_xml_string IN VARCHAR2) IS
  l_doc XMLDOM.DOMDocument;
  l_node_list XMLDOM.DOMNodeList;
  l_node XMLDOM.DOMNode;
  l_tag_name VARCHAR2(400);
  l_value VARCHAR2(4000);
BEGIN
  l_doc := XMLDOM.newDOMDocument(p_xml_string);
  l_node_list := XMLDOM.getElementsByTagName(l_doc, '*');
  FOR i IN 0..XMLDOM.getLength(l_node_list) - 1 LOOP
    l_node := XMLDOM.item(l_node_list, i);
    l_tag_name := XMLDOM.getNodeName(l_node);
    l_value := xmldom.getnodevalue(xmldom.getfirstchild(l_node));
    DBMS_OUTPUT.put_line(l_tag_name || ' = ' || l_value);
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
