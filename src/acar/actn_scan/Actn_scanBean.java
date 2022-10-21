/**
 * ��ų��� ��ĵ���� ����
 * @ author : Gill Sun Ryu
 * @ e-mail : koobu@gmail.com
 * @ create date : 2013. 02. 25
 * @ last modify date : 
 */
package acar.actn_scan;

import java.util.*;

public class Actn_scanBean {
    //Table : 	Actn_scanBean;
	private String actn_id;	//����� ���̵�
	private String actn_nm;	//������
	private String actn_dt;	//������
	private String actn_su;	//����Ƚ��
	private String reg_id;	//�����
	private String reg_dt;	//�����
	private String file_name1;	//����ڵ���� ÷������
	private String file_name2;	//����Ȯ�μ� ÷������
	private String file_name3;	//���ݰ�꼭 ÷������
        
    // CONSTRCTOR            
    public Actn_scanBean() {  
		this.actn_id = "";
		this.actn_nm = "";
		this.actn_dt = "";
		this.actn_su = "";
		this.reg_id = "";
		this.reg_dt = "";
		this.file_name1 = "";
		this.file_name2 = "";
		this.file_name3 = "";
	}

	// get Method
	public void setActn_id(String val){
		if(val==null) val="";
		this.actn_id = val;
	}
	public void setActn_nm(String val){
		if(val==null) val="";
		this.actn_nm = val;
	}
	public void setActn_dt(String val){
		if(val==null) val="";
		this.actn_dt = val;
	}
	public void setActn_su(String val){
		if(val==null) val="";
		this.actn_su = val;
	}
	public void setReg_id(String val){
		if(val==null) val="";
		this.reg_id = val;
	}
	public void setReg_dt(String val){
		if(val==null) val="";
		this.reg_dt = val;
	}
	public void setFile_name1(String val){
		if(val==null) val="";
		this.file_name1 = val;
	}
	public void setFile_name2(String val){
		if(val==null) val="";
		this.file_name2 = val;
	}
	public void setFile_name3(String val){
		if(val==null) val="";
		this.file_name3 = val;
	}

	//Get Method
	public String getActn_id(){
		return actn_id;
	}
	public String getActn_nm(){
		return actn_nm;
	}
	public String getActn_dt(){
		return actn_dt;
	}
	public String getActn_su(){
		return actn_su;
	}
	public String getReg_id(){
		return reg_id;
	}
	public String getReg_dt(){
		return reg_dt;
	}
	public String getFile_name1(){
		return file_name1;
	}
	public String getFile_name2(){
		return file_name2;
	}
	public String getFile_name3(){
		return file_name3;
	}
	
	
}