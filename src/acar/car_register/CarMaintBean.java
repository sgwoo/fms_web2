/**
 * ������������
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_register;

import java.util.*;

public class CarMaintBean {
    //Table : CAR_MAINT
    private String car_mng_id;			//�ڵ���������ȣ
	private int seq_no;					//SEQ_NO
	private String che_kd;				//��������
	private String che_st_dt;			//����������ȿ�Ⱓ1
	private String che_end_dt;			//����������ȿ�Ⱓ2
	private String che_dt;				//����������������
	private String che_no;				//�ǽ��ڰ�����ȣ
	private String che_comp;			//�ǽ��ھ�ü��
	private int che_amt;				//�ǽú��ݾ�	//�߰� 2004.01.07.
	private int che_km;					//����Ÿ�	//�߰� 2004.01.12.
	private String m1_dt;				//����Ÿ�Ƿ���.
	private String reg_id;				//���(����)
	private String reg_dt;				//
   	private String che_remark;				// Ư�̻���     
        
    // CONSTRCTOR            
    public CarMaintBean() {  
	    this.car_mng_id = "";			//�ڵ���������ȣ
		this.seq_no = 0;				//SEQ_NO
		this.che_kd = "";				//��������
		this.che_st_dt = "";			//����������ȿ�Ⱓ1
		this.che_end_dt = "";			//����������ȿ�Ⱓ2
		this.che_dt = "";				//����������������
		this.che_no = "";				//�ǽ��ڰ�����ȣ
		this.che_comp = "";				//�ǽ��ھ�ü��
		this.che_amt = 0;				//�ǽú��ݾ�
		this.che_km = 0;				//����Ÿ�
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