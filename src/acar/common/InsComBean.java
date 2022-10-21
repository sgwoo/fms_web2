/**
 * ������������
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.common;

import java.util.*;

public class InsComBean {
    //Table : INS_COM
    private String ins_com_id;			//�����ID
	private String ins_com_nm;			//������̸�
	private String car_rate;			//���԰����
	private String ins_rate;			//������
	private String ext_date;			//����������	
	private String zip;					//�����ȣ
	private String addr;				//�ּ�
	private String ins_com_f_nm;		//�����Ǯ�̸�
	private String agnt_imgn_tel;		//����⵿��ȣ
	private String acc_tel;				//���������ȣ
        
    // CONSTRCTOR            
    public InsComBean() {  
	    this.ins_com_id = "";			//�����ID
		this.ins_com_nm = "";			//������̸�
		this.car_rate = "";				//���԰����
		this.ins_rate = "";				//������
		this.ext_date = "";				//����������		
		this.zip = "";					//�����ȣ
		this.addr = "";					//�ּ�
		this.ins_com_f_nm = "";			//�����Ǯ�̸�
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