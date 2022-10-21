package acar.common;

import java.util.*;

public class CodeBean {
    //Table : CDDE
    private String c_st;					//코드분류
    private String code;					//코드(순차적증가)
    private String nm_cd;					//사용코드명
    private String nm;						//명칭
	private String app_st;
    private String cms_bk;                  // cms용 은행코드
    private String gubun;					// 금융기관 구분 코드    
    private String use_yn;                  // 금융기관 사용유무
    private String etc;                 	
    private String bigo;                 	
    private String var1; //금융사-월상환료처리방식
    private String var2; //금융사-이자처리방식
    private String var3; //금융사-이자처리방식
    private String var4; //금융사-1회차 이자 일자계산
    private String var5; //금융사-마지막회차 이자 일자계산
    private String var6; //금융사-회차 일자계산시 시작일 포함여부 
        
    // CONSTRCTOR            
    public CodeBean() {  
    	this.c_st = "";						//코드분류
	    this.code = "";						//코드(순차적증가)
	    this.nm_cd = "";					//사용코드명
	    this.nm = "";						//명칭
		this.app_st = "";
		this.cms_bk = "";
		this.gubun = "";
		this.use_yn = "";
		this.etc = "";
		this.bigo = "";
		this.var1 = "";
		this.var2 = "";
		this.var3 = "";
		this.var4 = "";
		this.var5 = "";
		this.var6 = "";
	}

	// get Method
	public void setC_st		(String val){		if(val==null) val="";		this.c_st = val;	}
	public void setCode		(String val){		if(val==null) val="";		this.code = val;	}
	public void setNm_cd	(String val){		if(val==null) val="";		this.nm_cd = val;	}
	public void setNm		(String val){		if(val==null) val="";		this.nm = val;		}
	public void setApp_st	(String val){		if(val==null) val="";		this.app_st = val;	}
	public void setCms_bk	(String val){		if(val==null) val="";		this.cms_bk = val;	}
	public void setGubun	(String val){		if(val==null) val="";		this.gubun = val;	}
	public void setUse_yn	(String val){		if(val==null) val="";		this.use_yn = val;	}
	public void setEtc		(String val){		if(val==null) val="";		this.etc = val;		}
	public void setBigo		(String val){		if(val==null) val="";		this.bigo = val;	}
	public void setVar1		(String val){		if(val==null) val="";		this.var1 = val;	}
	public void setVar2		(String val){		if(val==null) val="";		this.var2 = val;	}
	public void setVar3		(String val){		if(val==null) val="";		this.var3 = val;	}
	public void setVar4		(String val){		if(val==null) val="";		this.var4 = val;	}
	public void setVar5		(String val){		if(val==null) val="";		this.var5 = val;	}
	public void setVar6		(String val){		if(val==null) val="";		this.var6 = val;	}
	
	//Get Method
	public String getC_st	(){		return c_st;	}
	public String getCode	(){		return code;	}
	public String getNm_cd	(){		return nm_cd;	}
	public String getNm		(){		return nm;		}
	public String getApp_st	(){		return app_st;	}	
	public String getCms_bk	(){		return cms_bk;	}	
	public String getGubun	(){		return gubun;	}	
	public String getUse_yn	(){		return use_yn;	}	
	public String getEtc	(){		return etc;		}	
	public String getBigo	(){		return bigo;	}	
	public String getVar1	(){		return var1;	}
	public String getVar2	(){		return var2;	}
	public String getVar3	(){		return var3;	}
	public String getVar4	(){		return var4;	}
	public String getVar5	(){		return var5;	}
	public String getVar6	(){		return var6;	}

}