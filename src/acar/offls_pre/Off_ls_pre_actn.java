/**
 * 오프리스 매각준비차량 경매장별 구비서류 정보
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 03. 03. Mon.
 * @ last modify date : 
 */
package acar.offls_pre;

import java.util.*;

			

public class Off_ls_pre_actn 
{
	//Table : ACTN_DOC 경매장별 구비서류
	private String id;
	private String nm;
	private String saup_no;
	private String dev_zipcode;
	private String dev_addr;
	private String saup_zipcode;
	private String saup_addr;

	public Off_ls_pre_actn(){
		this.id = "";
		this.nm = "";
		this.saup_no = "";
		this.dev_zipcode = "";
		this.dev_addr = "";
		this.saup_zipcode = "";
		this.saup_addr = "";
	}

	//setMethod
	public void setId(String val){ if(val==null) val=""; this.id = val; }
	public void setNm(String val){ if(val==null) val=""; this.nm = val; }
	public void setSaup_no(String val){ if(val==null) val=""; this.saup_no = val; }
	public void setDev_zipcode(String val){ if(val==null) val=""; this.dev_zipcode = val; }
	public void setDev_addr(String val){ if(val==null) val=""; this.dev_addr = val; }
	public void setSaup_zipcode(String val){ if(val==null) val=""; this.saup_zipcode = val; }
	public void setSaup_addr(String val){ if(val==null) val=""; this.saup_addr = val; }

	//getMethod
	public String getId(){ return id; }
	public String getNm(){ return nm; }
	public String getDev_zipcode(){ return dev_zipcode; }
	public String getDev_addr(){ return dev_addr; }
	public String getSaup_zipcode(){ return saup_zipcode; }
	public String getSaup_addr(){ return saup_addr; }
	public String getSauo_no(){ return saup_no; }
}
