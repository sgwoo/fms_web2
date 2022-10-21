/**
 * 고객지원 차량진단 빈
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 12. 23. 화.
 * @ last modify date : - 2004.7.15. SpeedCheckBean 에서 SpdchkBean 으로 변경
 */
package acar.cus_reg;

import java.util.*;

public class SpdchkBean {
	//speedcheck 차량진단
	private String chk_id;
	private String chk_nm;
	private String chk_cont;

	
    public SpdchkBean() {
		this.chk_id = "";
		this.chk_nm = "";
		this.chk_cont = "";
	}

	public void setChk_id(String val){if(val==null) val="";	this.chk_id = val;}
	public void setChk_nm(String val){if(val==null) val="";	this.chk_nm = val;}
	public void setChk_cont(String val){if(val==null) val="";	this.chk_cont = val;}
	
	public String getChk_id(){return chk_id; }
	public String getChk_nm(){return chk_nm; }
	public String getChk_cont(){return chk_cont; }

}
