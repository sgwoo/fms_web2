/*
 * 부서
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.user_mng;

import java.util.*;

public class MenuBean {
    //Table : MENU M_CD 대메뉴 : 00
    private String m_st;					//대메뉴 구분
    private String m_st2;					//중메뉴 구분
    private String m_cd;					//소메뉴 구분
    private String m_nm;					//메뉴명
	private String m_gu;					//메뉴구분2
    private String url;						//url
    private String note;					//비고
    private int seq;						//순번
    private int seq_no;						//서브메뉴SEQ
	private String sm_nm;					//서브메뉴명
	private String base;					//기본페이지체크
    
        
    // CONSTRCTOR            
    public MenuBean() {  
    	this.m_st = "";					//대메뉴 구분
    	this.m_st2 = "";				//중메뉴 구분
	    this.m_cd = "";					//소메뉴 구분
	    this.m_nm = "";					//메뉴명
		this.m_gu = "";
	    this.url = "";					//url
	    this.note = "";					//비고
	    this.seq = 0;						//순번
	    this.seq_no = 0;						//서브메뉴SEQ
		this.sm_nm = "";					//서브메뉴명
		this.base = "";
	}

	// get Method
	public void setM_st(String val){
		if(val==null) val="";
		this.m_st = val;
	}
	public void setM_st2(String val){
		if(val==null) val="";
		this.m_st2 = val;
	}
	public void setM_cd(String val){
		if(val==null) val="";
		this.m_cd = val;
	}
	public void setM_nm(String val){
		if(val==null) val="";
		this.m_nm = val;
	}
	public void setM_gu(String val){
		if(val==null) val="";
		this.m_gu = val;
	}
	public void setUrl(String val){
		if(val==null) val="";
		this.url = val;
	}
	public void setNote(String val){
		if(val==null) val="";
		this.note = val;
	}
	public void setSeq(int val){
		this.seq = val;
	}
	public void setSeq_no(int val){
		this.seq_no = val;
	}
	public void setSm_nm(String val){
		if(val==null) val="";
		this.sm_nm = val;
	}	
	public void setBase(String val){
		if(val==null) val="";
		this.base = val;
	}	

	//Get Method
	
	public String getM_st(){
		return m_st;
	}
	public String getM_st2(){
		return m_st2;
	}
	public String getM_cd(){
		return m_cd;
	}
	public String getM_nm(){
		return m_nm;
	}
	public String getM_gu(){
		return m_gu;
	}
	public String getUrl(){
		return url;
	}
	public String getNote(){
		return note;
	}
	public int getSeq(){
		return seq;
	}
	public int getSeq_no(){
		return seq_no;
	}
	public String getSm_nm(){
		return sm_nm;
	}
	public String getBase(){
		return base;
	}
}