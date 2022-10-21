/**
 * �����׿� ���� ���λ��� ��ȸ
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.condition;

import java.util.*;

public class ClsCondBean {
    //Table : CONT, CAR_REG, CLIENT, FEE, USERS, CAR_PUR, CAR_ETC, CAR_NM, ALLOT, CODE
    private String rent_mng_id;					//������ID
    private String rent_l_cd;					//����ڵ�
    private String client_id;					//��ID
    private String client_nm;					//�� ��ǥ�ڸ�
    private String firm_nm;						//��ȣ
    private String car_no;						//������ȣ
    private String cls_st;
    private String cls_st_nm;
    private String term_yn;
    private String cls_dt;
    private String reg_id;
    private String reg_nm;
    private String cls_cau;
	private String car_name;
    
    // CONSTRCTOR            
    public ClsCondBean() {  
    	this.rent_mng_id = "";					//������ID
	    this.rent_l_cd = "";					//����ڵ�
	    this.client_id = "";					//��ID
	    this.client_nm = "";					//�� ��ǥ�ڸ�
	    this.firm_nm = "";						//��ȣ
	    this.car_no = "";						//������ȣ
	    this.cls_st = "";
	    this.cls_st_nm = "";
	    this.term_yn = "";
	    this.cls_dt = "";
	    this.reg_id = "";
	    this.reg_nm = "";
	    this.cls_cau = "";
		this.car_name = "";
	}

	// get Method
	public void setRent_mng_id(String val){
		if(val==null) val="";
		this.rent_mng_id = val;
	}
    public void setRent_l_cd(String val){
		if(val==null) val="";
		this.rent_l_cd = val;
	}
	public void setClient_id(String val){
		if(val==null) val="";
		this.client_id = val;
	}
    public void setClient_nm(String val){
		if(val==null) val="";
		this.client_nm = val;
	}
    public void setFirm_nm(String val){
		if(val==null) val="";
		this.firm_nm = val;
	}
    public void setCar_no(String val){
		if(val==null) val="";
		this.car_no = val;
	}
    public void setCls_st(String val){
		if(val==null) val="";
		this.cls_st = val;
	}
    public void setCls_st_nm(String val){
		if(val==null) val="";
		this.cls_st_nm = val;
	}
    public void setTerm_yn(String val){
		if(val==null) val="";
		this.term_yn = val;
	}
	public void setCls_dt(String val){
		if(val==null) val="";
		this.cls_dt = val;
	}
    public void setReg_id(String val){
		if(val==null) val="";
		this.reg_id = val;
	}
    public void setReg_nm(String val){
		if(val==null) val="";
		this.reg_nm = val;
	}
    public void setCls_cau(String val){
		if(val==null) val="";
		this.cls_cau = val;
	}
	public void setCar_name(String val){
		if(val==null) val="";
		this.car_name = val;
	}
	
	//Get Method
	public String getRent_mng_id(){
		return rent_mng_id;
	}
    public String getRent_l_cd(){
		return rent_l_cd;
	}
	public String getClient_id(){
		return client_id;
	}
    public String getClient_nm(){
		return client_nm;
	}
    public String getFirm_nm(){
		return firm_nm;
	}
    public String getCar_no(){
		return car_no;
	}
    public String getCls_st(){
		return cls_st;
	}
    public String getCls_st_nm(){
		if(cls_st.equals("1")){
			cls_st_nm = "��ุ��";	
		}else if(cls_st.equals("2")){
			cls_st_nm = "�ߵ��ؾ�";
		}else if(cls_st.equals("3")){
			cls_st_nm = "�����Һ���";
		}else if(cls_st.equals("4")){
			cls_st_nm = "��������";
		}else if(cls_st.equals("5")){
			cls_st_nm = "���°�";
		}else if(cls_st.equals("6")){
			cls_st_nm = "�Ű�";
		}else if(cls_st.equals("7")){
			cls_st_nm = "���������(����)";
		}else if(cls_st.equals("8")){
			cls_st_nm = "���Կɼ�";
		}else if(cls_st.equals("9")){
			cls_st_nm = "����";
		}else if(cls_st.equals("10")){
			cls_st_nm = "����������(�縮��)";	
		}else if(cls_st.equals("14")){
			cls_st_nm = "����Ʈ����";		
		}else if(cls_st.equals("15")){
			cls_st_nm = "����";				
		}
		return cls_st_nm;
	}
    public String getTerm_yn(){
		return term_yn;
	}
	public String getCls_dt(){
		return cls_dt;
	}
    public String getReg_id(){
		return reg_id;
	}
    public String getReg_nm(){
		return reg_nm;
	}
    public String getCls_cau(){
		return cls_cau;
	}
	public String getCar_name(){
		return car_name;
	}
}