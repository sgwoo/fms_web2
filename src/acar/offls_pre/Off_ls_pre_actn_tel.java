/**
 * 오프리스 매각준비차량 경매장별 담당자 연락처 정보
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 02. 28. Fri.
 * @ last modify date : 
 */
package acar.offls_pre;

import java.util.*;

public class Off_ls_pre_actn_tel 
{
	//Table : ACTN_actn_id 경매장별 담당연락처
	private String client_id;
	private String seq;
	private String gubun;
	private String name;
	private String title;
	private String tel;
	private String mobile;
	private String fax;

	public Off_ls_pre_actn_tel(){
		this.client_id = "";
		this.seq = "";
		this.gubun = "";
		this.name = "";
		this.title = "";
		this.tel = "";
		this.mobile = "";
		this.fax = "";
	}

	//setMethod
	public void setClient_id(String val){ if(val==null) val=""; this.client_id = val; }
	public void setSeq(String val){ if(val==null) val=""; this.seq = val; }
	public void setGubun(String val){ if(val==null) val=""; this.gubun = val; }
	public void setName(String val){ if(val==null) val=""; this.name = val; }
	public void setTitle(String val){ if(val==null) val=""; this.title = val; }
	public void setTel(String val){ if(val==null) val=""; this.tel = val; }
	public void setMobile(String val){ if(val==null) val=""; this.mobile = val; }
	public void setFax(String val){ if(val==null) val=""; this.fax = val; }

	//getMethod
	public String getClient_id(){ return client_id; }
	public String getSeq(){ return seq; }
	public String getGubun(){ return gubun; }
	public String getName(){ return name; }
	public String getTitle(){ return title; }
	public String getTel(){ return tel; }
	public String getMobile(){ return mobile; }
	public String getFax(){ return fax; }
}
