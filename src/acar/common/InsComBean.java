/**
 * 정기점검정비
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.common;

import java.util.*;

public class InsComBean {
    //Table : INS_COM
    private String ins_com_id;			//보험사ID
	private String ins_com_nm;			//보험사이름
	private String car_rate;			//가입경력율
	private String ins_rate;			//보험율
	private String ext_date;			//할인할증율	
	private String zip;					//우편번호
	private String addr;				//주소
	private String ins_com_f_nm;		//보험사풀이름
	private String agnt_imgn_tel;		//긴급출동번호
	private String acc_tel;				//사고접수번호
        
    // CONSTRCTOR            
    public InsComBean() {  
	    this.ins_com_id = "";			//보험사ID
		this.ins_com_nm = "";			//보험사이름
		this.car_rate = "";				//가입경력율
		this.ins_rate = "";				//보험율
		this.ext_date = "";				//할인할증율		
		this.zip = "";					//우편번호
		this.addr = "";					//주소
		this.ins_com_f_nm = "";			//보험사풀이름
		this.agnt_imgn_tel = "";		
		this.acc_tel = "";						
	}

	// get Method
	public void setIns_com_id(String val){
		if(val==null) val="";
		this.ins_com_id = val;
	}
	public void setIns_com_nm(String val){
		if(val==null) val="";
		this.ins_com_nm = val;
	}
	public void setCar_rate(String val){
		if(val==null) val="";
		this.car_rate = val;
	}
	public void setIns_rate(String val){
		if(val==null) val="";
		this.ins_rate = val;
	}
	public void setExt_date(String val){
		if(val==null) val="";
		this.ext_date = val;
	}
	public void setZip(String val){
		if(val==null) val="";
		this.zip = val;
	}
	public void setAddr(String val){
		if(val==null) val="";
		this.addr = val;
	}
	public void setIns_com_f_nm(String val){
		if(val==null) val="";
		this.ins_com_f_nm = val;
	}
	public void setAgnt_imgn_tel(String val){
		if(val==null) val="";
		this.agnt_imgn_tel = val;
	}
	public void setAcc_tel(String val){
		if(val==null) val="";
		this.acc_tel = val;
	}
	
	
	//Get Method
	public String getIns_com_id(){
		return ins_com_id;
	}
	public String getIns_com_nm(){
		return ins_com_nm;
	}
	public String getCar_rate(){
		return car_rate;
	}
	public String getIns_rate(){
		return ins_rate;
	}
	public String getExt_date(){
		return ext_date;
	}	
	public String getZip(){
		return zip;
	}
	public String getAddr(){
		return addr;
	}
	public String getIns_com_f_nm(){
		return ins_com_f_nm;
	}
	public String getAgnt_imgn_tel(){
		return agnt_imgn_tel;
	}
	public String getAcc_tel(){
		return acc_tel;
	}
}