package acar.bad_cust;

import java.util.*;

public class BadCustBean {
    //Table : BAD_CUST
    private String seq;					//��ȣ
    private String bc_nm;				//����
    private String bc_ent_no;			//�ֹε�Ϲ�ȣ
    private String bc_lic_no;			//���������ȣ
    private String bc_addr;				//�ּ�
    private String bc_firm_nm;			//���ؾ�ü��
    private String bc_cont;				//���س���
    private String reg_id;				//�����
    private String reg_dt;				//�����
	//20180827 �ҷ������� �߰�
    private String bc_m_tel;			//�޴�����ȣ
    private String bc_email;			//�̸����ּ�
    private String bc_fax;				//�ѽ���ȣ

		
    // CONSTRCTOR            
    public BadCustBean() {  
    	this.seq = "";					
	    this.bc_nm = "";				
	    this.bc_ent_no = "";			
	    this.bc_lic_no = "";			
	    this.bc_addr = "";				
	    this.bc_firm_nm = "";			
	    this.bc_cont = "";				
	    this.reg_id = "";
	    this.reg_dt = "";
	    this.bc_m_tel = "";				
	    this.bc_email = "";			
	    this.bc_fax = "";				
	}

	// get Method
	public void setSeq(String val){			if(val==null) val="";	this.seq = val;			}
	public void setBc_nm(String val){		if(val==null) val="";	this.bc_nm = val;		}
	public void setBc_ent_no(String val){	if(val==null) val="";	this.bc_ent_no = val;	}
	public void setBc_lic_no(String val){	if(val==null) val="";	this.bc_lic_no = val;	}
	public void setBc_addr(String val){		if(val==null) val="";	this.bc_addr = val;		}
	public void setBc_firm_nm(String val){	if(val==null) val="";	this.bc_firm_nm = val;	}
	public void setBc_cont(String val){		if(val==null) val="";	this.bc_cont = val;		}
	public void setReg_id(String val){		if(val==null) val="";	this.reg_id = val;		}
	public void setReg_dt(String val){		if(val==null) val="";	this.reg_dt = val;		}	
	public void setBc_m_tel(String val){	if(val==null) val="";	this.bc_m_tel = val;	}
	public void setBc_email(String val){	if(val==null) val="";	this.bc_email = val;	}
	public void setBc_fax(String val){		if(val==null) val="";	this.bc_fax = val;		}
	
	
	//Get Method
	public String getSeq(){			return seq;			}
	public String getBc_nm(){		return bc_nm;		}
	public String getBc_ent_no(){	return bc_ent_no;	}
	public String getBc_lic_no(){	return bc_lic_no;	}
	public String getBc_addr(){		return bc_addr;		}
	public String getBc_firm_nm(){	return bc_firm_nm;	}
	public String getBc_cont(){		return bc_cont;		}
	public String getReg_id(){		return reg_id;		}
	public String getReg_dt(){		return reg_dt;		}
	public String getBc_m_tel(){	return bc_m_tel;	}
	public String getBc_email(){	return bc_email;	}
	public String getBc_fax(){		return bc_fax;		}

}