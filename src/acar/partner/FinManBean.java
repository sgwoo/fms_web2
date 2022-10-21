/**
 * 인사카드 - 협력업체 등록 테이블 Partner_office
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2009. 1. 9
 * @ last modify date : 
 */
package acar.partner;

import java.util.*;

public class FinManBean {
    //Table : Fin_Man
         private int fin_seq;				//순번
  	private String com_nm;			//회사명
	private String br_nm;			//지점명
	private String agnt_nm;			//담당자
	private String agnt_title;			//직급
	private String fin_tel;			//전화번호
	private String fin_fax;			//fax
	private String fin_email;			//이메일
	private String fin_zip;			//우편번호
	private String fin_addr;			//주소
	private String use_yn;			//사용여부
	private String gubun;			//구분 ( 재무제표, 보험료)
	private String fin_m_tel;			//모바일
	private int sort;			//sort
	

    // CONSTRCTOR            
public FinManBean() {  
	this.fin_seq =0;				//
  	this.com_nm = "";				//
	this.br_nm = "";				//
	this.agnt_nm = "";				//
	this.agnt_title = "";				//
	this.fin_tel = "";				//
	this.fin_fax = "";				//
	this.fin_email = "";				//
	this.fin_zip = "";				//
	this.fin_addr = "";				//
	this.use_yn = "";				//
	this.gubun = "";				//
	this.fin_m_tel = "";				//
	this.sort = 0;				//

	}

	// set Method
	public void setFin_seq		(int val)   {									this.fin_seq			= val;	}	
	public void setCom_nm(String val){		if(val==null) val="";		this.com_nm = val;	}
	public void setBr_nm(String val){		if(val==null) val="";		this.br_nm = val;	}
	public void setAgnt_nm(String val){		if(val==null) val="";		this.agnt_nm = val;	}
	public void setAgnt_title(String val){		if(val==null) val="";		this.agnt_title = val;	}
	public void setFin_tel(String val){		if(val==null) val="";		this.fin_tel = val;	}
	public void setFin_fax(String val){	if(val==null) val="";		this.fin_fax = val;}
	public void setFin_email(String val){		if(val==null)val = "";		this.fin_email = val;	}
	public void setFin_zip(String val){		if(val==null)val = "";		this.fin_zip = val;	}
	public void setFin_addr(String val){		if(val==null)val = "";		this.fin_addr = val;	}
	public void setUse_yn(String val){		if(val==null)val = "";		this.use_yn = val;	}
	public void setGubun(String val){		if(val==null)val = "";		this.gubun = val;	}
	public void setFin_m_tel(String val){	if(val==null)val = "";		this.fin_m_tel = val;}
	public void setSort		(int val)   {									this.sort			= val;	}	

					
	//Get Method
	public int 	getFin_seq(){			return fin_seq;	}
	public String	getCom_nm(){			return com_nm;	}
	public String	getBr_nm(){		return br_nm;	}
	public String	getAgnt_nm(){		return agnt_nm;	}
	public String	getAgnt_title(){		return agnt_title;}
	public String	getFin_tel(){		return fin_tel;}
	public String	getFin_fax(){		return fin_fax;}
	public String	getFin_email(){			return fin_email;}
	public String	getFin_zip(){		return fin_zip;}
	public String	getFin_addr(){			return fin_addr;}
	public String	getUse_yn(){		return use_yn;}
	public String	getGubun(){		return gubun;}
	public String	getFin_m_tel(){		return fin_m_tel;}
	public int	getSort(){		return sort;}
	
}