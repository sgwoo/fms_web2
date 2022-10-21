/**
 * �������
 * @ author : Seng, Seung Hyun
 * @ start-date : 2016-02-23

 */
package acar.complain;

import java.util.*;
	
public class OpinionBean {
    //Table : COMPLAIN �Ҹ�����
	private int seq; 						//����
	private String gubun; 					//C:  ����, P: Ī��, O:�ǰ� 
	private String email; 					//�̸���
	private String name; 					//�̸�
	private String tel; 					//��ȭ��ȣ
	private String acar_use; 				//�Ƹ���ī �̿뿩��
	private String title; 					//����
	private String contents; 				//�������
	private String reg_dt;					//��Ͻð�
	private String answer;					//�亯
	private String ans_id;					//�亯�� id
	private String ans_nm;					//�亯�� �̸�
	private String ans_dt;					//�亯�ð�
	        
    // CONSTRCTOR            
    public OpinionBean() {
    		this.seq = 0; 					//����
    		this.gubun = ""; 			//C:  ����, P: Ī��, O:�ǰ� 
    		this.email = ""; 				//�̸���
			this.name = ""; 				//�̸�
			this.tel = "";					//��ȭ��ȣ
			this.acar_use = ""; 			//�Ƹ���ī �̿뿩��
			this.title = ""; 				//����
			this.contents = ""; 			//�������	
			this.reg_dt = ""; 				//��Ͻð�
			this.answer = ""; 				//�亯
			this.ans_id = ""; 				//�亯�� id
			this.ans_nm = ""; 				//�亯��
			this.ans_dt = ""; 				//�亯�ð�
		
	}

	// set Method
	public void setSeq(int val){this.seq = val;}	
	public void setGubun(String val){if(val==null) val=""; this.gubun = val;}
	public void setEmail(String val){if(val==null) val=""; this.email = val;}
	public void setName(String val){if(val==null) val="";	this.name= val;}
	public void setTel(String val){if(val==null) val="";	this.tel = val;}
	public void setAcar_use(String val){	if(val==null) val=""; this.acar_use = val;}
	public void setTitle(String val){if(val==null) val=""; this.title = val;}
	public void setContents(String val){if(val==null) val=""; this.contents = val;}
	public void setReg_dt(String val){if(val==null) val=""; this.reg_dt = val;}
	public void setAnswer(String val){if(val==null) val=""; this.answer = val;}
	public void setAns_id(String val){if(val==null) val=""; this.ans_id = val;}
	public void setAns_nm(String val){if(val==null) val=""; this.ans_nm = val;}
	public void setAns_dt(String val){if(val==null) val=""; this.ans_dt = val;}
	

	//get Method
	public int getSeq(){return seq;}
	public String getGubun(){return gubun;}
	public String getEmail(){return email;}
	public String getName(){return name;}
	public String getTel(){return tel;}	
	public String getAcar_use(){return acar_use;}
	public String getTitle(){return title;}
	public String getContents(){return contents;}
	public String getReg_dt(){return reg_dt;}
	public String getAnswer(){return answer;}
	public String getAns_id(){return ans_id;}
	public String getAns_nm(){return ans_nm;}
	public String getAns_dt(){return ans_dt;}
	
	
}