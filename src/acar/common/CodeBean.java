package acar.common;

import java.util.*;

public class CodeBean {
    //Table : CDDE
    private String c_st;					//�ڵ�з�
    private String code;					//�ڵ�(����������)
    private String nm_cd;					//����ڵ��
    private String nm;						//��Ī
	private String app_st;
    private String cms_bk;                  // cms�� �����ڵ�
    private String gubun;					// ������� ���� �ڵ�    
    private String use_yn;                  // ������� �������
    private String etc;                 	
    private String bigo;                 	
    private String var1; //������-����ȯ��ó�����
    private String var2; //������-����ó�����
    private String var3; //������-����ó�����
    private String var4; //������-1ȸ�� ���� ���ڰ��
    private String var5; //������-������ȸ�� ���� ���ڰ��
    private String var6; //������-ȸ�� ���ڰ��� ������ ���Կ��� 
        
    // CONSTRCTOR            
    public CodeBean() {  
    	this.c_st = "";						//�ڵ�з�
	    this.code = "";						//�ڵ�(����������)
	    this.nm_cd = "";					//����ڵ��
	    this.nm = "";						//��Ī
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