CREATE OR REPLACE
package mspks_interpay_gen as

TYPE tbls IS TABLE OF VARCHAR2(1500) INDEX BY BINARY_INTEGER;

Function fn_set_file_hdr(p_file_type IN varchar2,
				p_file_id OUT	Varchar2,
				p_hdr 	OUT	varchar2,
				perrcode	OUT	Varchar2,
				perrparam	OUT	Varchar2)
return boolean ;

Function fn_set_file_ftr(p_ftr	OUT	Varchar2,
				  p_err_code 	IN OUT Varchar2,
				  p_errparams	IN OUT Varchar2
				)
Return Boolean;

Function fn_set_batch_hdr(p_trn_group	IN Varchar2,
				  p_ac_no		IN Varchar2,
				  p_ccy		IN Varchar2,
				  p_batch_hdr	OUT Varchar,
				  p_err_code 	IN OUT Varchar2,
				  p_errparams	IN OUT Varchar2)

Return Boolean ;

Function fn_set_transaction_info ( p_file_type IN varchar2,
						p_ccy  IN Varchar2,
					     p_account IN Varchar2,
					     p_err_code IN OUT Varchar,
						p_errparams IN OUT Varchar2
						)
Return boolean ;

Function fn_set_batch_ftr ( p_account  IN		STTMS_CUST_ACCOUNT.CUST_AC_NO%TYPE,
					   p_ccy	  IN		CYTMS_CCY_DEFN.CCY_CODE%TYPE,
					   p_err_code IN OUT	Varchar2,
					   p_errparams IN OUT	Varchar2,
					  p_batch_ftr OUT Varchar )
Return Boolean ;

FUNCTION fn_write_file(
      p_directory       IN      VARCHAR2,
      p_filename        IN OUT  VARCHAR2,
      p_msg             IN      tbls,
      p_mode            IN      VARCHAR2
	) RETURN BOOLEAN ;

Function fn_gen_interpay (p_txt_file_name IN varchar2,
				p_file_type IN 	   Char,  				p_gen_type	IN	Char ,
				p_txn_account IN Varchar2,
				p_dup_date IN DATE ,
				p_err_code  IN OUT Varchar2,
				  p_errparams IN OUT Varchar2)
Return boolean ;

Function fn_set_instr_party (p_gen_type	IN	Char , --Test/Production
					p_instr_info OUT Varchar2,
					p_err_code  IN OUT Varchar2,
				  	p_errparams IN OUT Varchar2)
Return boolean ;

end  mspks_interpay_gen;
/