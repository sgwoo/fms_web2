/**
 * 정비업체
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.serv_off;

import java.util.*;

public class ServOffBean {
    //Table : CAR_REG
	private String off_id; 
	private String car_comp_id; 
	private String off_nm; 
	private String off_st;
	private String off_st_nm; 
	private String own_nm; 
	private String ent_no; 
	private String off_sta; 
	private String off_item; 
	private String off_tel; 
	private String off_fax; 
	private String homepage; 
	private String off_post; 
	private String off_addr; 
	private String bank; 
	private String acc_no; 
	private String acc_nm; 
	private String note;
	private String off_type;
	
        
    // CONSTRCTOR            
    public ServOffBean() {  
		this.off_id = ""; 
		this.car_comp_id = ""; 
		this.off_nm = ""; 
		this.off_st = "";
		this.off_st_nm = ""; 
		this.own_nm = ""; 
		this.ent_no = ""; 
		this.off_sta = ""; 
		this.off_item = ""; 
		this.off_tel = ""; 
		this.off_fax = ""; 
		this.homepage = ""; 
		this.off_post = ""; 
		this.off_addr = ""; 
		this.bank = ""; 
		this.acc_no = ""; 
		this.acc_nm = ""; 
		this.note = "";
		this.off_type = "";
	}

	// get Method

	public void setOff_id(String val){
		if(val==null) val="";
		this.off_id = val;
	}
	public void setCar_comp_id(String val){
		if(val==null) val="";
		this.car_comp_id = val;
	}
	public void setOff_nm(String val){
		if(val==null) val="";
		this.off_nm = val;
	}
	public void setOff_st(String val){
		if(val==null) val="";
		this.off_st = val;
	}
	public void setOwn_nm(String val){
		if(val==null) val="";
		this.own_nm = val;
	}
	public void setEnt_no(String val){
		if(val==null) val="";
		this.ent_no = val;
	}
	public void setOff_sta(String val){
		if(val==null) val="";
		this.off_sta = val;
	}
	public void setOff_item(String val){
		if(val==null) val="";
		this.off_item = val;
	}
	public void setOff_tel(String val){
		if(val==null) val="";
		this.off_tel = val;
	}
	public void setOff_fax(String val){
		if(val==null) val="";
		this.off_fax = val;
	}
	public void setHomepage(String val){
		if(val==null) val="";
		this.homepage = val;
	}
	public void setOff_post(String val){
		if(val==null) val="";
		this.off_post = val;
	}
	public void setOff_addr(String val){
		if(val==null) val="";
		this.off_addr = val;
	}
	public void setBank(String val){
		if(val==null) val="";
		this.bank = val;
	}
	public void setAcc_no(String val){
		if(val==null) val="";
		this.acc_no = val;
	}
	public void setAcc_nm(String val){
		if(val==null) val="";
		this.acc_nm = val;
	}
	public void setNote(String val){
		if(val==null) val="";
		this.note = val;
	}
	public void setOff_type(String val){
		if(val==null) val="";
		this.off_type = val;
	}
		
	//Get Method
	public String getOff_id(){
		return off_id;
	}
	public String getCar_comp_id(){
		return car_comp_id;
	}
	public String getOff_nm(){
		return off_nm;
	}
	public String getOff_st(){
		return off_st;
	}
	public String getOff_st_nm(){
		if(off_st.equals("6"))
		{
			off_st_nm = "기타";
		}else{
			off_st_nm = off_st + " 급";
		}
		return off_st_nm;
	}
	public String getOwn_nm(){
		return own_nm;
	}
	public String getEnt_no(){
		return ent_no;
	}
	public String getOff_sta(){
		return off_sta;
	}
	public String getOff_item(){
		return off_item;
	}
	public String getOff_tel(){
		return off_tel;
	}
	public String getOff_fax(){
		return off_fax;
	}
	public String getHomepage(){
		return homepage;
	}
	public String getOff_post(){
		return off_post;
	}
	public String getOff_addr(){
		return off_addr;
	}
	public String getBank(){
		return bank;
	}
	public String getAcc_no(){
		return acc_no;
	}
	public String getAcc_nm(){
		return acc_nm;
	}
	public String getNote(){
		return note;
	}
	public String getOff_type(){
		return note;
	}
}