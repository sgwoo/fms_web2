/**
 * �ڵ���ȸ��
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_office;

import java.util.*;

public class CarCompBean {
    //Table : CDDE C_ST  �ڵ���ȸ�簪 : 0001
    private String c_st;					//�ڵ�з�
    private String code;					//�ڵ�(����������)
    private String nm_cd;					//����ڵ��
    private String nm;						//�ڵ���ȸ���̸�
    private String etc;						//���
    private String app_st;					//��ó
    private String cms_bk;					//��������
	private String bigo;					//DC�ݿ�����
	 
        
    // CONSTRCTOR            
    public CarCompBean() {  
    	this.c_st = "";					//�ڵ�з�
	    this.code = "";					//�ڵ�(����������)
	    this.nm_cd = "";				//����ڵ��
	    this.nm = "";					//�ڵ���ȸ���̸�
	    this.etc = "";					//���
	    this.app_st = "";			
	    this.cms_bk = "";			
	    this.bigo = "";			
	}

	// get Method
	public void setC_st		(String val){		if(val==null) val="";		this.c_st	= val;	}
	public void setCode		(String val){		if(val==null) val="";		this.code	= val;	}
	public void setNm_cd	(String val){		if(val==null) val="";		this.nm_cd	= val;	}
	public void setNm		(String val){		if(val==null) val="";		this.nm		= val;	}
	public void setEtc		(String val){		if(val==null) val="";		this.etc	= val;	}
	public void setApp_st	(String val){		if(val==null) val="";		this.app_st	= val;	}
	public void setCms_bk	(String val){		if(val==null) val="";		this.cms_bk	= val;	}
	public void setBigo		(String val){		if(val==null) val="";		this.bigo	= val;	}
	
		
	//Get Method
	public String getC_st	(){		return c_st;	}
	public String getCode	(){		return code;	}
	public String getNm_cd	(){		return nm_cd;	}
	public String getNm		(){		return nm;		}
	public String getEtc	(){		return etc;		}
	public String getApp_st	(){		return app_st;	}
	public String getCms_bk	(){		return cms_bk;	}
	public String getBigo	(){		return bigo;	}
	
	
}