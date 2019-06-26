
CREATE TABLE iftb_branch_recon
 (
  xref                       VARCHAR2(35) NOT NULL,
  origxref                   VARCHAR2(35),
  recontype                  CHAR(1),
  reconamt                   NUMBER,
  drcrind                    CHAR(1),
  msgtype                    VARCHAR2(10) NOT NULL,
  respstat                   CHAR(1),
  currstat                   CHAR(1),
  reqtype                    VARCHAR2(35),
  srcxml                     CLOB,
  respxml                    CLOB,
  branchcode                 VARCHAR2(10),
  keyval                     VARCHAR2(1000),
  ovdconf                    CHAR(1),
  makerid                    VARCHAR2(20),
  checkerid                  VARCHAR2(20),
  dcn_list                   VARCHAR2(1000)
 )
/




CREATE TABLE iftb_brn_recon_hist
 (
  xref                       VARCHAR2(35),
  run_date                   DATE,
  origxref                   VARCHAR2(35),
  recontype                  CHAR(1),
  reconamt                   NUMBER,
  drcrind                    CHAR(1),
  msgtype                    VARCHAR2(10),
  respstat                   CHAR(1),
  currstat                   CHAR(1),
  reqtype                    VARCHAR2(35),
  srcxml                     CLOB,
  respxml                    CLOB,
  branchcode                 VARCHAR2(10),
  keyval                     VARCHAR2(1000),
  ovdconf                    CHAR(1),
  makerid                    VARCHAR2(20),
  checkerid                  VARCHAR2(20)
 )
/




CREATE TABLE sttm_cust_image
 (
  customer_no                VARCHAR2(9),
  seq_no                     NUMBER(2),
  image                      BLOB,
  image_text                 CLOB
 )
/




CREATE TABLE svtm_cif_sig_det
 (
  cif_id                     VARCHAR2(9) NOT NULL,
  cif_sig_id                 VARCHAR2(9) NOT NULL,
  specimen_no                NUMBER(1) NOT NULL,
  specimen_seq_no            NUMBER(4),
  signature                  VARCHAR2(2000),
  record_stat                CHAR(1),
  sign_img                   BLOB
 )
/


