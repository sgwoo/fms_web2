/**
 * �׿��� �ŷ�ó
 */
package acar.bill_mng;

import java.util.*;

public class TradeBean {
    private String cust_code;	//�ŷ�ó�ڵ�
    private String cust_name;	//�ŷ�ó��
    private String s_idno;		//����ڵ�Ϲ�ȣ
    private String id_no;		//�ֹε�Ϲ�ȣ
    private String dname;		//��ǥ�ڸ�
    private String mail_no;		//�����ȣ
	private String s_address;	//�ŷ�ó�ּ�
    private String uptae;		//����
    private String jong;		//����
    private String user_id;		
    private String dc_rmk;		//��Ÿ
    private String md_gubun;	//����/����
    private String ven_st;		//��������
    private String reg_dt;
        
    // CONSTRCTOR            
    public TradeBean() {  
    	this.cust_code	= "";
    	this.cust_name	= "";
	    this.s_idno		= "";
	    this.id_no		= "";
	    this.dname		= "";
	    this.mail_no	= "";
	    this.s_address	= "";
	    this.uptae		= "";
	    this.jong		= "";
	    this.user_id	= "";
		this.dc_rmk		= "";
		this.md_gubun	= "Y";
		this.ven_st		= "";
		this.reg_dt		= "";
	}

	// get Method
	public void setCust_code(String val){		if(val==null) val="";		this.cust_code	= val;	}
	public void setCust_name(String val){		if(val==null) val="";		this.cust_name	= val;	}
	public void setS_idno	(String val){		if(val==null) val="";		this.s_idno		= val;	}
	public void setId_no	(String val){		if(val==null) val="";		this.id_no		= val;	}
	public void setDname	(String val){		if(val==null) val="";		this.dname		= val;	}
	public void setMail_no	(String val){		if(val==null) val="";		this.mail_no	= val;	}
	public void setS_address(String val){		if(val==null) val="";		this.s_address	= val;	}
	public void setUptae	(String val){		if(val==null) val="";		this.uptae		= val;	}
	public void setJong		(String val){		if(val==null) val="";		this.jong		= val;	}
	public void setUser_id	(String val){		if(val==null) val="";		this.user_id	= val;	}
	public void setDc_rmk	(String val){		if(val==null) val="";		this.dc_rmk		= val;	}
	public void setMd_gubun	(String val){		if(val==null) val="";		this.md_gubun	= val;	}
	public void setVen_st	(String val){		if(val==null) val="";		this.ven_st		= val;	}
	public void setReg_dt	(String val){		if(val==null) val="";		this.reg_dt		= val;	}

	//Get Method
	public String getCust_code	(){		return cust_code;	}
	public String getCust_name	(){		return cust_name;	}
	public String getS_idno		(){		return s_idno;		}
	public String getId_no		(){		return id_no;		}
	public String getDname		(){		return dname;		}
	public String getMail_no	(){		return mail_no;		}
	public String getS_address	(){		return s_address;	}
	public String getUptae		(){		return uptae;		}
	public String getJong		(){		return jong;		}
	public String getUser_id	(){		return user_id;		}
	public String getDc_rmk		(){		return dc_rmk;		}
	public String getMd_gubun	(){		return md_gubun;	}
	public String getVen_st		(){		return ven_st;		}
	public String getReg_dt		(){		return reg_dt;		}
}
