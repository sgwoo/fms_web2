/**
 * 사고기록
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.accid;

import java.util.*;

public class OneAccidBean {
    //Table : CAR_REG
	private String car_mng_id; 					//자동차관리번호
	private String accid_id;
	private int seq_no;
	private String nm;
	private String sex;
	private String hosp;
	private String hosp_tel;
	private String ins_nm;
	private String ins_tel;
	private String tel;
	private String age;
	private String relation;
	private String diagnosis;
	private String etc;
	private String one_accid_st;
	private String wound_st;
	private int ot_seq_no;
	
        
    // CONSTRCTOR            
    public OneAccidBean() {  
		this.car_mng_id = ""; 					//자동차관리번호
		this.accid_id = "";
		this.seq_no = 0;
		this.nm = "";
		this.sex = "";
		this.hosp = "";
		this.hosp_tel = "";
		this.ins_nm = "";
		this.ins_tel = "";
		this.tel = "";
		this.age = "";
		this.relation = "";
		this.diagnosis = "";
		this.etc = "";
		this.one_accid_st = "";
		this.wound_st = "";
		this.ot_seq_no = 0;
	}

	// get Method
	public void setCar_mng_id(String val){
		if(val==null) val="";
		this.car_mng_id = val;
	}
	public void setAccid_id(String val){
		if(val==null) val="";
		this.accid_id = val;
	}
	public void setSeq_no(int val){
		this.seq_no = val;
	}
	public void setNm(String val){
		if(val==null) val="";
		this.nm = val;
	}
	public void setSex(String val){
		if(val==null) val="";
		this.sex = val;
	}
	public void setHosp(String val){
		if(val==null) val="";
		this.hosp = val;
	}
	public void setHosp_tel(String val){
		if(val==null) val="";
		this.hosp_tel = val;
	}
	public void setIns_nm(String val){
		if(val==null) val="";
		this.ins_nm = val;
	}
	public void setIns_tel(String val){
		if(val==null) val="";
		this.ins_tel = val;
	}
	public void setTel(String val){
		if(val==null) val="";
		this.tel = val;
	}
	public void setAge(String val){
		if(val==null) val="";
		this.age = val;
	}
	public void setRelation(String val){
		if(val==null) val="";
		this.relation = val;
	}
	public void setDiagnosis(String val){
		if(val==null) val="";
		this.diagnosis = val;
	}
	public void setEtc(String val){
		if(val==null) val="";
		this.etc = val;
	}
	public void setOne_accid_st(String val){
		if(val==null) val="";
		this.one_accid_st = val;
	}
	public void setWound_st(String val){	if(val==null) val="";	this.wound_st = val;	}
	public void setOt_seq_no(int val){			this.ot_seq_no = val;		}

		
	//Get Method
	public String getCar_mng_id(){
		return car_mng_id;
	}
	public String getAccid_id(){
		return accid_id;
	}
	public int getSeq_no(){
		return seq_no;
	}
	public String getNm(){
		return nm;
	}
	public String getSex(){
		return sex;
	}
	public String getHosp(){
		return hosp;
	}
	public String getHosp_tel(){
		return hosp_tel;
	}
	public String getIns_nm(){
		return ins_nm;
	}
	public String getIns_tel(){
		return ins_tel;
	}
	public String getTel(){
		return tel;
	}
	public String getAge(){
		return age;
	}
	public String getRelation(){
		return relation;
	}
	public String getDiagnosis(){
		return diagnosis;
	}
	public String getEtc(){
		return etc;
	}
	public String getOne_accid_st(){
		return one_accid_st;
	}
	public String getWound_st(){	return wound_st;	}
	public int getOt_seq_no(){		return ot_seq_no;	}
	
}