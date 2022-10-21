/**
 * 정기점검정비
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_register;

import java.util.*;

public class CarMaintBean {
    //Table : CAR_MAINT
    private String car_mng_id;			//자동차관리번호
	private int seq_no;					//SEQ_NO
	private String che_kd;				//점검종별
	private String che_st_dt;			//점검정비유효기간1
	private String che_end_dt;			//점검정비유효기간2
	private String che_dt;				//점검정비점검일자
	private String che_no;				//실시자고유번호
	private String che_comp;			//실시자업체명
	private int che_amt;				//실시비용금액	//추가 2004.01.07.
	private int che_km;					//주행거리	//추가 2004.01.12.
	private String m1_dt;				//마스타의뢰일.
	private String reg_id;				//등록(갱신)
	private String reg_dt;				//
   	private String che_remark;				// 특이사항     
        
    // CONSTRCTOR            
    public CarMaintBean() {  
	    this.car_mng_id = "";			//자동차관리번호
		this.seq_no = 0;				//SEQ_NO
		this.che_kd = "";				//점검종별
		this.che_st_dt = "";			//점검정비유효기간1
		this.che_end_dt = "";			//점검정비유효기간2
		this.che_dt = "";				//점검정비점검일자
		this.che_no = "";				//실시자고유번호
		this.che_comp = "";				//실시자업체명
		this.che_amt = 0;				//실시비용금액
		this.che_km = 0;				//주행거리
		this.m1_dt = "";				// 
		this.che_remark  = "";				// 
	}

	// get Method
	public void setCar_mng_id(String val){
		if(val==null) val="";
		this.car_mng_id = val;
	}
	public void setSeq_no(int val){
		this.seq_no = val;
	}
	public void setChe_kd(String val){
		if(val==null) val="";
		this.che_kd = val;
	}
	public void setChe_st_dt(String val){
		if(val==null) val="";
		this.che_st_dt = val;
	}
	public void setChe_end_dt(String val){
		if(val==null) val="";
		this.che_end_dt = val;
	}
	public void setChe_dt(String val){
		if(val==null) val="";
		this.che_dt = val;
	}
	public void setChe_no(String val){
		if(val==null) val="";
		this.che_no = val;
	}
	public void setChe_comp(String val){
		if(val==null) val="";
		this.che_comp = val;
	}
	public void setChe_amt(int val){ this.che_amt = val; }
	public void setChe_km(int val){ this.che_km = val; }
		
	public void setM1_dt(String val){	if(val==null) val="";		this.m1_dt = val;	}
	
	public void setReg_id(String val){	if(val==null) val="";		this.reg_id = val;	}
	public void setReg_dt(String val){	if(val==null) val="";		this.reg_dt = val;	}
	
	public void setChe_remark(String val){	if(val==null) val="";		this.che_remark = val;	}
		
	//Get Method
	public String getCar_mng_id(){
		return car_mng_id;
	}
	public int getSeq_no(){
		return seq_no;
	}
	public String getChe_kd(){
		return che_kd;
	}
	public String getChe_st_dt(){
		return che_st_dt;
	}
	public String getChe_end_dt(){
		return che_end_dt;
	}
	public String getChe_dt(){
		return che_dt;
	}
	public String getChe_no(){
		return che_no;
	}
	public String getChe_comp(){
		return che_comp;
	}
	public int getChe_amt(){ return che_amt; }
	public int getChe_km(){ return che_km; }
	
	public String getM1_dt(){
		return m1_dt;
	}
	
	public String getReg_id(){
		return reg_id;
	}
	
	public String getReg_dt(){
		return reg_dt;
	}
	
	public String getChe_remark(){
		return che_remark;
	}
}