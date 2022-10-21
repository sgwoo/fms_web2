/**
 * 인사카드 - 협력업체 등록 테이블 Partner_office
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2009. 1. 9
 * @ last modify date : 
 */
package acar.partner;

import java.util.*;

public class Partner_Bean {
    //Table : Partner_Bean
    private String po_id;				//업체 아이디
  	private String br_id;				//등록지점
	private String reg_dt;				//등록일
	private String user_id;				//등록한사람
	private String upd_dt;				//수정일
	private String upd_id;				//수정한사람
	private String po_gubun;			//구분(1-자동차회사, 2-정비업체, 3-탁송업체, 4-기타)
	private String po_nm;				//상호/단체명
	private String po_own;				//대표
	private String po_no;				//사업자번호
	private String po_sta;				//업태
	private String po_item;				//종목
	private String po_o_tel;			//전화번호
	private String po_m_tel;			//핸드폰번호
	private String po_fax;				//팩스
	private String po_post;				//우편번호
	private String po_addr;				//주소
	private String po_web;				//홈페이지 주소
	private String po_note;				//기타 특이사항
	private String po_agnt_nm;			//담당자
	private String po_agnt_m_tel;		//담당자
	private String po_agnt_o_tel;		//담당자
	private String po_login_id;			//id
	private String po_login_ps;			//pass
	private String po_email;			//담당자이메일주소

    // CONSTRCTOR            
public Partner_Bean() {  
	this.po_id = "";				//업체 아이디
  	this.br_id = "";				//등록지점
	this.reg_dt = "";				//등록일
	this.user_id = "";				//등록한사람
	this.upd_dt = "";				//수정일
	this.upd_id = "";				//수정한사람
	this.po_gubun = "";				//구분(1-자동차회사, 2-정비업체, 3-탁송업체, 4-기타)
	this.po_nm = "";				//상호/단체명
	this.po_own = "";				//대표
	this.po_no = "";				//사업자번호
	this.po_sta = "";				//업태
	this.po_item = "";				//종목
	this.po_o_tel = "";				//전화번호
	this.po_m_tel = "";				//핸드폰번호
	this.po_fax = "";				//팩스
	this.po_post = "";				//우편번호
	this.po_addr = "";				//주소
	this.po_web = "";				//홈페이지 주소
	this.po_note = "";				//기타 특이사항
	this.po_agnt_nm = "";			
	this.po_agnt_m_tel = "";			
	this.po_agnt_o_tel = "";		
	this.po_login_id = "";			//id
	this.po_login_ps = "";			//pass
	this.po_email = "";				//담당자이메일주소
	}

	// set Method
	public void setPo_id(String val){		if(val==null) val="";		this.po_id = val;	}	
	public void setBr_id(String val){		if(val==null) val="";		this.br_id = val;	}
	public void setReg_dt(String val){		if(val==null) val="";		this.reg_dt = val;	}
	public void setUser_id(String val){		if(val==null) val="";		this.user_id = val;	}
	public void setUpd_dt(String val){		if(val==null) val="";		this.upd_dt = val;	}
	public void setUpd_id(String val){		if(val==null) val="";		this.upd_id = val;	}
	public void setPo_gubun(String val){	if(val==null) val="";		this.po_gubun = val;}
	public void setPo_nm(String val){		if(val==null)val = "";		this.po_nm = val;	}
	public void setPo_own(String val){		if(val==null)val = "";		this.po_own = val;	}
	public void setPo_no(String val){		if(val==null)val = "";		this.po_no = val;	}
	public void setPo_sta(String val){		if(val==null)val = "";		this.po_sta = val;	}
	public void setPo_item(String val){		if(val==null)val = "";		this.po_item = val;	}
	public void setPo_o_tel(String val){	if(val==null)val = "";		this.po_o_tel = val;}
	public void setPo_m_tel(String val){	if(val==null)val = "";		this.po_m_tel = val;}
	public void setPo_fax(String val){		if(val==null)val = "";		this.po_fax = val;	}
	public void setPo_post(String val){		if(val==null)val = "";		this.po_post = val;	}
	public void setPo_addr(String val){		if(val==null)val = "";		this.po_addr = val;	}
	public void setPo_web(String val){		if(val==null)val = "";		this.po_web = val;	}
	public void setPo_note(String val){		if(val==null)val = "";		this.po_note = val;	}
	public void setPo_agnt_nm	(String val){	if(val==null)val = "";		this.po_agnt_nm = val;	}
	public void setPo_agnt_m_tel(String val){	if(val==null)val = "";		this.po_agnt_m_tel = val;	}
	public void setPo_agnt_o_tel(String val){	if(val==null)val = "";		this.po_agnt_o_tel = val;	}
	public void setPo_login_id(String val){		if(val==null)val = "";		this.po_login_id = val;	}
	public void setPo_login_ps(String val){		if(val==null)val = "";		this.po_login_ps = val;	}
	public void setPo_email(String val){		if(val==null)val = "";		this.po_email = val;	}
				
	//Get Method
	public String 	getPo_id(){			return po_id;	}
	public String	getBr_id(){			return br_id;	}
	public String	getReg_dt(){		return reg_dt;	}
	public String	getUser_id(){		return user_id;	}
	public String	getUpd_dt(){		return upd_dt;}
	public String	getUpd_id(){		return upd_id;}
	public String	getPo_gubun(){		return po_gubun;}
	public String	getPo_nm(){			return po_nm;}
	public String	getPo_own(){		return po_own;}
	public String	getPo_no(){			return po_no;}
	public String	getPo_sta(){		return po_sta;}
	public String	getPo_item(){		return po_item;}
	public String	getPo_o_tel(){		return po_o_tel;}
	public String	getPo_m_tel(){		return po_m_tel;}
	public String	getPo_fax(){		return po_fax;}
	public String	getPo_post(){		return po_post;	}
	public String	getPo_addr(){		return po_addr;	}
	public String	getPo_web(){		return po_web;	}
	public String	getPo_note(){		return po_note;	}
	public String	getPo_agnt_nm	(){		return po_agnt_nm;	}
	public String	getPo_agnt_m_tel(){		return po_agnt_m_tel;	}
	public String	getPo_agnt_o_tel(){		return po_agnt_o_tel;	}
	public String	getPo_login_id(){		return po_login_id;	}
	public String	getPo_login_ps(){		return po_login_ps;	}
	public String	getPo_email(){			return po_email;	}


}