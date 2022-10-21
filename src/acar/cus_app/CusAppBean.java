/**
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2004.8.12.
 * @ last modify date : 
 */
package acar.cus_app;

import java.util.*;

public class CusAppBean {
	private String client_id;
	private String aaa;	//외형-사무실-소유
    private String aab;	//외형-사무실-크기
   	private String aac;	//외형-사무실-규모
    private String aad;	//외형-사무실-환경
	private String aae;	//외형-사무실-사무집기
    private String aba;	//외형-공장-소유
    private String abb;	//외형-공장-규모
    private String abc;	//외형-공장-환경
    private String abd;	//외형-공장-사무집기
    private String aca;	//외형-근무인원-사무실
	private String acb;	//외형-근무인원-공장
	private String acc; //외형-근무인원-전월대비변동인원
   	private String ada;	//외형-자동차-업무용
   	private String adb;	//외형-자동차-경쟁사차량
   	private String baa;	//호감도-대표-대표
   	private String bba;	//호감도-차량담당자-부서
	private String bbb; //호감도-차량담당자-성명
   	private String bbc;	//호감도-차량담당자-호감도
   	private String bbd;	//호감도-차량담당자-기타특징
   	private String bca;	//호감도-회계담당자-부서
   	private String bcb;	//호감도-회계담당자-성명
   	private String bcc;	//호감도-회계담당자-호감도
   	private String bcd;	//호감도-회계담당자-기타특징
   	private String bda;	//호감도-차량이용자-부서
   	private String bdb;	//호감도-차량이용자-성명
   	private String bdc;	//호감도-차량이용자-호감도
   	private String bdd;	//호감도-차량이용자-기타특징
   	private String caa;	//평가-결재
   	private String cbb;	//평가-성장성
   	private String ccc;	//평가-거래확장가능성
   	private String cdd;	//평가-종합판단
	      	    
   	// CONSTRCTOR            
   	public CusAppBean() {
		this.client_id = "";
   		this.aaa= "";	
    	this.aab= "";					
    	this.aac= "";					
    	this.aad= "";					
    	this.aae= "";					
    	this.aba= "";					 
		this.abb= "";					
		this.abc= "";					  
		this.abd= "";					  
		this.aca= "";					
		this.acb= "";					
    	this.acc= "";					
    	this.ada= "";					
    	this.adb= "";						
    	this.baa= "";
    	this.bba= "";
    	this.bbb= "";
    	this.bbc= "";					
    	this.bbd= "";					
    	this.bca= "";					
    	this.bcb= "";					
    	this.bcc= "";						
    	this.bcd= "";						
    	this.bda= "";
    	this.bdb= "";					
    	this.bdc= "";					
    	this.bdd= "";						
    	this.caa= "";						
    	this.cbb= "";
    	this.ccc= "";
		this.cdd= "";
	}
	
	// SET Method
	public void setClient_id(String val){ if(val==null) val=""; this.client_id = val; }
	public void setAaa(String val){	if(val==null) val="";	this.aaa = val;	}
   	public void setAab(String val){	if(val==null) val="";	this.aab = val;	}
	public void setAac(String val){	if(val==null) val="";	this.aac = val;	}
	public void setAad(String val){	if(val==null) val="";	this.aad = val;	}	
	public void setAae(String val){	if(val==null) val="";	this.aae = val;	}	
	public void setAba(String val){	if(val==null) val="";	this.aba = val;	}
	public void setAbb(String val){	if(val==null) val="";	this.abb = val;	}
	public void setAbc(String val){	if(val==null) val="";	this.abc = val;	}
	public void setAbd(String val){	if(val==null) val="";	this.abd = val;	}
	public void setAca(String val){	if(val==null) val="";	this.aca = val;	}
	public void setAcb(String val){	if(val==null) val="";	this.acb = val;	}
	public void setAcc(String val){	if(val==null) val="";	this.acc = val;	}
   	public void setAda(String val){	if(val==null) val="";	this.ada = val;	}
   	public void setAdb(String val){	if(val==null) val="";	this.adb = val;	}
   	public void setBaa(String val){	if(val==null) val="";	this.baa = val;	}
	public void setBba(String val){	if(val==null) val="";	this.bba = val;	}
	public void setBbb(String val){ if(val==null) val="";	this.bbb = val; }
	public void setBbc(String val){	if(val==null) val="";	this.bbc = val;	}
	public void setBbd(String val){	if(val==null) val="";	this.bbd = val;	}
	public void setBca(String val){	if(val==null) val="";	this.bca = val;	}
   	public void setBcb(String val){	if(val==null) val="";	this.bcb = val;	}
   	public void setBcc(String val){	if(val==null) val="";	this.bcc = val;	}
	public void setBcd(String val){	if(val==null) val="";	this.bcd = val;	}
	public void setBda(String val){	if(val==null) val="";	this.bda = val;	}
   	public void setBdb(String val){	if(val==null) val="";	this.bdb = val;	}
   	public void setBdc(String val){	if(val==null) val="";	this.bdc = val;	}
   	public void setBdd(String val){	if(val==null) val="";	this.bdd = val;	}
	public void setCaa(String val){	if(val==null) val="";	this.caa = val;	}
   	public void setCbb(String val){	if(val==null) val="";	this.cbb = val;	}
	public void setCcc(String val){	if(val==null) val="";	this.ccc = val;	}
   	public void setCdd(String val){	if(val==null) val="";	this.cdd = val;	}
		
	//GET Method
	public String getClient_id(){ return client_id; }
	public String getAaa(){	return aaa;	}
   	public String getAab(){	return aab;	}
	public String getAac(){	return aac;	}
   	public String getAad(){	return aad;	}	
	public String getAae(){	return aae;	}	
	public String getAba(){	return aba;	}
	public String getAbb(){	return abb;	}
	public String getAbc(){	return abc;	}
	public String getAbd(){	return abd;	}
	public String getAca(){	return aca;	}
	public String getAcb(){	return acb;	}
	public String getAcc(){	return acc;	}
   	public String getAda(){	return ada;	}
   	public String getAdb(){	return adb;	}
   	public String getBaa(){	return baa;	}
	public String getBba(){	return bba;	}
	public String getBbb(){ return bbb; }
	public String getBbc(){	return bbc;	}
	public String getBbd(){	return bbd;	}
	public String getBca(){	return bca;	}
   	public String getBcb(){	return bcb;	}
   	public String getBcc(){	return bcc;	}
	public String getBcd(){	return bcd;	}
   	public String getBda(){	return bda;	}
   	public String getBdb(){	return bdb;	}
   	public String getBdc(){	return bdc;	}
	public String getBdd(){	return bdd;	}
   	public String getCaa(){	return caa;	}
	public String getCbb(){	return cbb;	}
   	public String getCcc(){	return ccc;	}
   	public String getCdd(){	return cdd;	}
}