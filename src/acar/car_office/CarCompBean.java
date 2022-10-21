/**
 * 자동차회사
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_office;

import java.util.*;

public class CarCompBean {
    //Table : CDDE C_ST  자동차회사값 : 0001
    private String c_st;					//코드분류
    private String code;					//코드(순차적증가)
    private String nm_cd;					//사용코드명
    private String nm;						//자동차회사이름
    private String etc;						//비고
    private String app_st;					//출처
    private String cms_bk;					//견적여부
	private String bigo;					//DC반영내용
	 
        
    // CONSTRCTOR            
    public CarCompBean() {  
    	this.c_st = "";					//코드분류
	    this.code = "";					//코드(순차적증가)
	    this.nm_cd = "";				//사용코드명
	    this.nm = "";					//자동차회사이름
	    this.etc = "";					//비고
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