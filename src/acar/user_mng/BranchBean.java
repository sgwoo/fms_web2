/*
 * 지점관리
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.user_mng;

import java.util.*;

public class BranchBean {
    //Table : BRANCH
    private String br_id;						//저점ID
    private String br_ent_no;					//사업자등록번호
    private String br_nm;						//법인명
    private String br_st_dt;					//개업년월일
    private String br_post;						//우편번호
    private String br_addr;						//주소
    private String br_item;						//종목
    private String br_sta;						//업태
    private String br_tax_o;					//관할세무서
    private String br_own_nm;					//대표자
    
    
        
    // CONSTRCTOR            
    public BranchBean() {  
    	this.br_id = "";						//저점ID
	    this.br_ent_no = "";					//사업자등록번호
	    this.br_nm = "";						//법인명
	    this.br_st_dt = "";						//개업년월일
	    this.br_post = "";						//우편번호
	    this.br_addr = "";						//주소
	    this.br_item = "";						//종목
	    this.br_sta = "";						//업태
	    this.br_tax_o = "";					//관할세무서
	    this.br_own_nm = "";					//대표자
	}

	// get Method
	public void setBr_id(String val){
		if(val==null) val="";
		this.br_id = val;
	}
	public void setBr_ent_no(String val){
		if(val==null) val="";
		this.br_ent_no = val;
	}
	public void setBr_nm(String val){
		if(val==null) val="";
		this.br_nm = val;
	}
	public void setBr_st_dt(String val){
		if(val==null) val="";
		this.br_st_dt = val;
	}
	public void setBr_post(String val){
		if(val==null) val="";
		this.br_post = val;
	}
	public void setBr_addr(String val){
		if(val==null) val="";
		this.br_addr = val;
	}
	public void setBr_item(String val){
		if(val==null) val="";
		this.br_item = val;
	}public void setBr_sta(String val){
		if(val==null) val="";
		this.br_sta = val;
	}
	public void setBr_tax_o(String val){
		if(val==null) val="";
		this.br_tax_o = val;
	}
	public void setBr_own_nm(String val){
		if(val==null) val="";
		this.br_own_nm = val;
	}
	
		
	//Get Method
	
	public String getBr_id(){
		return br_id;
	}
	public String getBr_ent_no(){
		return br_ent_no;
	}
	public String getBr_nm(){
		return br_nm;
	}
	public String getBr_st_dt(){
		return br_st_dt;
	}
	public String getBr_post(){
		return br_post;
	}
	public String getBr_addr(){
		return br_addr;
	}
	public String getBr_item(){
		return br_item;
	}
	public String getBr_sta(){
		return br_sta;
	}
	public String getBr_tax_o(){
		return br_tax_o;
	}
	public String getBr_own_nm(){
		return br_own_nm;
	}
	
}