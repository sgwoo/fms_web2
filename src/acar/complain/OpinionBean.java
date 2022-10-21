/**
 * 불편사항
 * @ author : Seng, Seung Hyun
 * @ start-date : 2016-02-23

 */
package acar.complain;

import java.util.*;
	
public class OpinionBean {
    //Table : COMPLAIN 불만접수
	private int seq; 						//순번
	private String gubun; 					//C:  불편, P: 칭찬, O:의견 
	private String email; 					//이메일
	private String name; 					//이름
	private String tel; 					//전화번호
	private String acar_use; 				//아마존카 이용여부
	private String title; 					//제목
	private String contents; 				//불편사항
	private String reg_dt;					//등록시간
	private String answer;					//답변
	private String ans_id;					//답변자 id
	private String ans_nm;					//답변자 이름
	private String ans_dt;					//답변시간
	        
    // CONSTRCTOR            
    public OpinionBean() {
    		this.seq = 0; 					//순번
    		this.gubun = ""; 			//C:  불편, P: 칭찬, O:의견 
    		this.email = ""; 				//이메일
			this.name = ""; 				//이름
			this.tel = "";					//전화번호
			this.acar_use = ""; 			//아마존카 이용여부
			this.title = ""; 				//제목
			this.contents = ""; 			//불편사항	
			this.reg_dt = ""; 				//등록시간
			this.answer = ""; 				//답변
			this.ans_id = ""; 				//답변자 id
			this.ans_nm = ""; 				//답변자
			this.ans_dt = ""; 				//답변시간
		
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