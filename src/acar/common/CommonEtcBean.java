package acar.common;

import java.util.*;

public class CommonEtcBean {
    //Table : COMMON_ETC
    private String table_nm;					//���̺��
    private String col_1_nm;					//�÷�1 �̸�  
    private String col_1_val;					//�÷�1 ��
    private String col_2_nm;					//�÷�2 �̸�  
    private String col_2_val;					//�÷�2 ��
    private String col_3_nm;					//�÷�3 �̸�  
    private String col_3_val;					//�÷�3 ��
    private String col_4_nm;					//�÷�4 �̸�  
    private String col_4_val;					//�÷�4 ��
    private String etc_nm;						//��Ÿ �̸�
    private String etc_content;                 //��Ÿ ����
    private String reg_id;						//��� ���̵�
    private String reg_dt;						//�����
        
    // CONSTRCTOR            
    public CommonEtcBean() {  
    	this.table_nm 	= "";					
	    this.col_1_nm 	= "";						   
	    this.col_1_val 	= "";				
	    this.col_2_nm 	= "";
	    this.col_2_val 	= "";
	    this.col_3_nm 	= "";						   
	    this.col_3_val 	= "";				
	    this.col_4_nm 	= "";
	    this.col_4_val 	= "";
	    this.etc_nm 	= "";
	    this.etc_content= "";
	    this.reg_id 	= "";
	    this.reg_dt 	= "";
	}

	// Set Method
	public void setTable_nm(String val){
		if(val==null) val="";
		this.table_nm = val;
	}
	public void setCol_1_nm(String val){
		if(val==null) val="";
		this.col_1_nm = val;
	}
	public void setCol_1_val(String val){
		if(val==null) val="";
		this.col_1_val = val;
	}
	public void setCol_2_nm(String val){
		if(val==null) val="";
		this.col_2_nm = val;
	}
	public void setCol_2_val(String val){
		if(val==null) val="";
		this.col_2_val = val;
	}
	public void setCol_3_nm(String val){
		if(val==null) val="";
		this.col_3_nm = val;
	}
	public void setCol_3_val(String val){
		if(val==null) val="";
		this.col_3_val = val;
	}
	public void setCol_4_nm(String val){
		if(val==null) val="";
		this.col_4_nm = val;
	}
	public void setCol_4_val(String val){
		if(val==null) val="";
		this.col_4_val = val;
	}
	public void setEtc_nm(String val){
		if(val==null) val="";
		this.etc_nm = val;
	}
	public void setEtc_content(String val){
		if(val==null) val="";
		this.etc_content = val;
	}
	public void setReg_id(String val){
		if(val==null) val="";
		this.reg_id = val;
	}
	public void setReg_dt(String val){
		if(val==null) val="";
		this.reg_dt = val;
	}
	
	//Get Method
	public String getTable_nm(){
		return table_nm;
	}
	public String getCol_1_nm(){
		return col_1_nm;
	}
	public String getCol_1_val(){
		return col_1_val;
	}
	public String getCol_2_nm(){
		return col_2_nm;
	}
	public String getCol_2_val(){
		return col_2_val;
	}
	public String getCol_3_nm(){
		return col_3_nm;
	}
	public String getCol_3_val(){
		return col_3_val;
	}
	public String getCol_4_nm(){
		return col_4_nm;
	}
	public String getCol_4_val(){
		return col_4_val;
	}
	public String getEtc_nm(){
		return etc_nm;
	}
	public String getEtc_content(){
		return etc_content;
	}
	public String getReg_id(){
		return reg_id;
	}
	public String getReg_dt(){
		return reg_dt;
	}
}