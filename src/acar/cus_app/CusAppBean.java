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
	private String aaa;	//����-�繫��-����
    private String aab;	//����-�繫��-ũ��
   	private String aac;	//����-�繫��-�Ը�
    private String aad;	//����-�繫��-ȯ��
	private String aae;	//����-�繫��-�繫����
    private String aba;	//����-����-����
    private String abb;	//����-����-�Ը�
    private String abc;	//����-����-ȯ��
    private String abd;	//����-����-�繫����
    private String aca;	//����-�ٹ��ο�-�繫��
	private String acb;	//����-�ٹ��ο�-����
	private String acc; //����-�ٹ��ο�-������񺯵��ο�
   	private String ada;	//����-�ڵ���-������
   	private String adb;	//����-�ڵ���-���������
   	private String baa;	//ȣ����-��ǥ-��ǥ
   	private String bba;	//ȣ����-���������-�μ�
	private String bbb; //ȣ����-���������-����
   	private String bbc;	//ȣ����-���������-ȣ����
   	private String bbd;	//ȣ����-���������-��ŸƯ¡
   	private String bca;	//ȣ����-ȸ������-�μ�
   	private String bcb;	//ȣ����-ȸ������-����
   	private String bcc;	//ȣ����-ȸ������-ȣ����
   	private String bcd;	//ȣ����-ȸ������-��ŸƯ¡
   	private String bda;	//ȣ����-�����̿���-�μ�
   	private String bdb;	//ȣ����-�����̿���-����
   	private String bdc;	//ȣ����-�����̿���-ȣ����
   	private String bdd;	//ȣ����-�����̿���-��ŸƯ¡
   	private String caa;	//��-����
   	private String cbb;	//��-���强
   	private String ccc;	//��-�ŷ�Ȯ�尡�ɼ�
   	private String cdd;	//��-�����Ǵ�
	      	    
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