/*
 * �μ�
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.user_mng;

import java.util.*;

public class MenuBean {
    //Table : MENU M_CD ��޴� : 00
    private String m_st;					//��޴� ����
    private String m_st2;					//�߸޴� ����
    private String m_cd;					//�Ҹ޴� ����
    private String m_nm;					//�޴���
	private String m_gu;					//�޴�����2
    private String url;						//url
    private String note;					//���
    private int seq;						//����
    private int seq_no;						//����޴�SEQ
	private String sm_nm;					//����޴���
	private String base;					//�⺻������üũ
    
        
    // CONSTRCTOR            
    public MenuBean() {  
    	this.m_st = "";					//��޴� ����
    	this.m_st2 = "";				//�߸޴� ����
	    this.m_cd = "";					//�Ҹ޴� ����
	    this.m_nm = "";					//�޴���
		this.m_gu = "";
	    this.url = "";					//url
	    this.note = "";					//���
	    this.seq = 0;						//����
	    this.seq_no = 0;						//����޴�SEQ
		this.sm_nm = "";					//����޴���
		this.base = "";
	}

	// get Method
	public void setM_st(String val){
		if(val==null) val="";
		this.m_st = val;
	}
	public void setM_st2(String val){
		if(val==null) val="";
		this.m_st2 = val;
	}
	public void setM_cd(String val){
		if(val==null) val="";
		this.m_cd = val;
	}
	public void setM_nm(String val){
		if(val==null) val="";
		this.m_nm = val;
	}
	public void setM_gu(String val){
		if(val==null) val="";
		this.m_gu = val;
	}
	public void setUrl(String val){
		if(val==null) val="";
		this.url = val;
	}
	public void setNote(String val){
		if(val==null) val="";
		this.note = val;
	}
	public void setSeq(int val){
		this.seq = val;
	}
	public void setSeq_no(int val){
		this.seq_no = val;
	}
	public void setSm_nm(String val){
		if(val==null) val="";
		this.sm_nm = val;
	}	
	public void setBase(String val){
		if(val==null) val="";
		this.base = val;
	}	

	//Get Method
	
	public String getM_st(){
		return m_st;
	}
	public String getM_st2(){
		return m_st2;
	}
	public String getM_cd(){
		return m_cd;
	}
	public String getM_nm(){
		return m_nm;
	}
	public String getM_gu(){
		return m_gu;
	}
	public String getUrl(){
		return url;
	}
	public String getNote(){
		return note;
	}
	public int getSeq(){
		return seq;
	}
	public int getSeq_no(){
		return seq_no;
	}
	public String getSm_nm(){
		return sm_nm;
	}
	public String getBase(){
		return base;
	}
}