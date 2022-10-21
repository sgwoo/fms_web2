/**
 * 오프리스 매각준비차량 경매장별 구비서류 정보
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 03. 03. Mon.
 * @ last modify date : 
 */
package acar.offls_pre;

import java.util.*;

public class Off_ls_pre_actn_doc 
{
	//Table : ACTN_DOC 경매장별 구비서류
	private String client_id;
	private String seq;
	private String doc_nm;
	private String doc_ck;
	private String car_mng_id;

	public Off_ls_pre_actn_doc(){
		this.client_id = "";
		this.seq = "";
		this.doc_nm = "";
		this.doc_ck = "";
		this.car_mng_id = "";
	}

	//setMethod
	public void setClient_id(String val){ if(val==null) val=""; this.client_id = val; }
	public void setSeq(String val){ if(val==null) val=""; this.seq = val; }
	public void setDoc_nm(String val){ if(val==null) val=""; this.doc_nm = val; }
	public void setDoc_ck(String val){ if(val==null) val=""; this.doc_ck = val; }
	public void setCar_mng_id(String val){ if(val==null) val=""; this.car_mng_id = val; }

	//getMethod
	public String getClient_id(){ return client_id; }
	public String getSeq(){ return seq; }
	public String getDoc_nm(){ return doc_nm; }
	public String getDoc_ck(){ return doc_ck; }
	public String getCar_mng_id(){ return car_mng_id; }
}
