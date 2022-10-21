/*
 * ��������
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.user_mng;

import java.util.*;

public class BranchBean {
    //Table : BRANCH
    private String br_id;						//����ID
    private String br_ent_no;					//����ڵ�Ϲ�ȣ
    private String br_nm;						//���θ�
    private String br_st_dt;					//���������
    private String br_post;						//�����ȣ
    private String br_addr;						//�ּ�
    private String br_item;						//����
    private String br_sta;						//����
    private String br_tax_o;					//���Ҽ�����
    private String br_own_nm;					//��ǥ��
    
    
        
    // CONSTRCTOR            
    public BranchBean() {  
    	this.br_id = "";						//����ID
	    this.br_ent_no = "";					//����ڵ�Ϲ�ȣ
	    this.br_nm = "";						//���θ�
	    this.br_st_dt = "";						//���������
	    this.br_post = "";						//�����ȣ
	    this.br_addr = "";						//�ּ�
	    this.br_item = "";						//����
	    this.br_sta = "";						//����
	    this.br_tax_o = "";					//���Ҽ�����
	    this.br_own_nm = "";					//��ǥ��
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