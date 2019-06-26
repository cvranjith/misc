CREATE OR REPLACE PACKAGE demo_soap AS 
 
  /* A type to represent a SOAP RPC request */ 
  TYPE request IS RECORD ( 
    method     VARCHAR2(256), 
    namespace  VARCHAR2(256), 
    body       VARCHAR2(32767)); 
 
  /* A type to represent a SOAP RPC response */ 
  TYPE response IS RECORD ( 
    doc xmltype); 
 
  /* 
   * Create a new SOAP RPC request. 
   */ 
  FUNCTION new_request(method    IN VARCHAR2, 
                       namespace IN VARCHAR2) 
                       RETURN request; 
 
  /* 
   * Add a simple parameter to the SOAP RPC request. 
   */ 
  PROCEDURE add_parameter(req   IN OUT NOCOPY request, 
                          name  IN VARCHAR2, 
                          type  IN VARCHAR2, 
                          value IN VARCHAR2); 
 
  /* 
   * Make the SOAP RPC call. 
   */ 
  FUNCTION invoke(req    IN OUT NOCOPY request, 
                  url    IN VARCHAR2, 
                  action IN VARCHAR2) RETURN response; 
 
  /* 
   * Retrieve the sipmle return value of the SOAP RPC call. 
   */ 
  FUNCTION get_return_value(resp      IN OUT NOCOPY response, 
                            name      IN VARCHAR2, 
                            namespace IN VARCHAR2) RETURN VARCHAR2; 
 
END; 
/ 

---  
CREATE OR REPLACE PACKAGE BODY demo_soap AS 
 
  FUNCTION new_request(method    IN VARCHAR2, 
                       namespace IN VARCHAR2) 
                       RETURN request AS 
    req request; 
  BEGIN 
    req.method    := method; 
    req.namespace := namespace; 
    RETURN req; 
  END; 
 
  PROCEDURE add_parameter(req   IN OUT NOCOPY request, 
                          name  IN VARCHAR2, 
                          type  IN VARCHAR2, 
                          value IN VARCHAR2) AS 
  BEGIN 
    req.body := req.body || 
       '<'||name||' xsi:type="'||type||'">'||value||'</'||name||'>'; 
  END; 
 
  PROCEDURE generate_envelope(req IN OUT NOCOPY request, 
                                          env IN OUT NOCOPY VARCHAR2) AS 
  BEGIN 
    env := '<SOAP-ENV:Envelope 
xmlns:SOAP-ENV="http://schemas..xmlsoap.org/soap/envelope/" 
xmlns:xsi="http://www.w3.org/1999/XMLSchema-instance" 
xmlns:xsd="http://www.w3.org/1999/XMLSchema"> 
<SOAP-ENV:Body><'||req.method||' '||req.namespace||' 
 SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">'|| 
req.body||'</'||req.method||'></SOAP-ENV:Body></SOAP-ENV:Envelope>'; 
  END; 
 
  PROCEDURE show_envelope(env IN VARCHAR2) AS 
    i   pls_integer; 
    len pls_integer; 
  BEGIN 
    i := 1; len := length(env); 
    WHILE (i <= len) LOOP 
      dbms_output.put_line(substr(env, i, 60)); 
      i := i + 60; 
    END LOOP; 
  END; 
 
  PROCEDURE check_fault(resp IN OUT NOCOPY response) AS 
    fault_node   xmltype; 
    fault_code   VARCHAR2(256); 
    fault_string VARCHAR2(32767); 
  BEGIN 
     fault_node := resp.doc.extract('/soap:Fault', 
       'xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/'); 
     IF (fault_node IS NOT NULL) THEN 
       fault_code := fault_node.extract('/soap:Fault/faultcode/child::text()', 
             'xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/').getstringval(); 
       fault_string := fault_node.extract('/soap:Fault/faultstring/child::text()', 
             'xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/').getstringval(); 
       raise_application_error(-20000, fault_code || ' - ' || fault_string); 
     END IF; 
  END; 
 
  FUNCTION invoke(req    IN OUT NOCOPY request, 
                  url    IN VARCHAR2, 
                  action IN VARCHAR2) RETURN response AS 
    env       VARCHAR2(32767); 
    http_req  utl_http.req; 
    http_resp utl_http.resp; 
    resp      response; 
  BEGIN   
    generate_envelope(req, env); 
    show_envelope(env); 
    http_req := utl_http.begin_request(url, 'POST','HTTP/1.0'); 
    utl_http.set_header(http_req, 'Content-Type', 'text/xml'); 
    utl_http.set_header(http_req, 'Content-Length', length(env)); 
    utl_http.set_header(http_req, 'SOAPAction', action); 
    utl_http.write_text(http_req, env); 
    http_resp := utl_http.get_response(http_req); 
    utl_http.read_text(http_resp, env); 
    utl_http.end_response(http_resp); 
    resp.doc := xmltype.createxml(env); 
    resp.doc := resp.doc.extract('/soap:Envelope/soap:Body/child::node()', 
      'xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"'); 
    show_envelope(resp.doc.getstringval()); 
    check_fault(resp); 
    RETURN resp; 
  END; 
 
  FUNCTION get_return_value(resp      IN OUT NOCOPY response, 
                            name      IN VARCHAR2, 
                            namespace IN VARCHAR2) RETURN VARCHAR2 AS 
  BEGIN 
      RETURN resp.doc.extract('//'||name||'/child::text()', 
      namespace).getstringval(); 
  END; 
 
END; 
/
create or replace function get_HelloWorld (proxy_server  IN VARCHAR2, 
                                             web_service  IN VARCHAR2, 
                                             web_service_param IN VARCHAR2) 
  RETURN STRING IS 
     req  demo_soap.request; 
     resp demo_soap.response; 
     a varchar2(30); 
  BEGIN 
    utl_http.set_proxy(proxy_server, NULL); 
    utl_http.set_persistent_conn_support(TRUE); 
 
    req := demo_soap.new_request('sayHelloWorld','xmlns="Hello"'); 
     demo_soap.add_parameter(req, 'name', 'xsd:string', web_service_param); 
     resp := demo_soap.invoke(req, web_service  ,  ''); 
    a:= demo_soap.get_return_value(resp, 'return', 
      'xmlns:ns1="Hello"'); 
       
    return a; 
END;
/
