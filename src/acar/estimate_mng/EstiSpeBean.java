/**
 * ����������
 */
package acar.estimate_mng;

import java.util.*;


public class EstiSpeBean {
    //Table : ESTI_SPE
    private String est_id;		//������ȣ(�⵵2�ڸ�+��2�ڸ�+����(f=fms,w=web,s=special)1�ڸ�+�Ϸù�ȣ4�ڸ�)
    private String est_st;		//������
	private String est_nm;		//��/��ȣ��
    private String est_ssn;		//�ֹ�/����ڵ�Ϲ�ȣ
    private String est_agnt;	//�����
    private String est_tel;		//����ó
    private String est_bus;		//����
    private String est_year;	//����
    private String car_nm;		//�������
    private String etc;			//��Ÿ
    private String reg_dt;		//�����
	private String est_area;	//�������
    private String est_fax;		//�ѽ�
    private String car_nm2;		//�������2
    private String car_nm3;		//�������3
	private	String reg_id;		//�ۼ��� - ������û 
	private String est_email;	//�̸���
	private String client_yn;	//����������

	private String m_user_id;	//��ȭ�����
	private String m_reg_dt;	//��ȭ�����
	private String rent_yn;		//���ü�Ῡ��
	private String est_gubun;	//��㱸��
    private String t_user_id;	//��ȭ��ȭ��
    private String t_reg_dt;	//��ȭ��ȭ��
    private String t_note;	 
    private String b_note;		//��ȭ�� �̷������ ���� ���
    private String b_reg_dt;	//��ȭ�� �̷������ ���� ���
	private String county;		//����������
	
	//201610 Ȩ������ ������ : ����û �� �������� ����
	private String zipcode;		//�����ȣ
	private String addr1;		//�ּ�1
	private String addr2;		//�ּ�2
	private String account;		//���¹�ȣ
    private String bank;		//����
	private String driver_year;	//����-�������
    private String urgen_tel;	//������ȣ
	//20170412
    private String est_comp_ceo;	//��ǥ�ڸ�
    private String est_comp_tel;	//ȸ�翬��ó
    private String est_comp_cel;	//��ǥ�ڿ���ó
    //20180313
    private String car_use_addr1;	//�����̿��� �ּ�1
    private String car_use_addr2;	//�����̿��� �ּ�2
    
    private String br_to;
    private String br_to_st;
    private String br_from;
	private String br_from_st;


    // CONSTRCTOR            
    public EstiSpeBean() {  
    	this.est_id			= "";
    	this.est_st			= "";
	    this.est_nm			= "";
	    this.est_ssn		= "";
	    this.est_tel		= "";
	    this.est_fax		= "";
	    this.est_agnt		= "";
	    this.est_bus		= "";
	    this.est_year		= "";
	    this.car_nm			= "";
	    this.etc			= "";
	    this.reg_dt			= "";
		this.m_user_id		= "";
		this.m_reg_dt		= "";
		this.rent_yn		= "";
		this.est_area		= "";
		this.est_gubun		= "";
	    this.car_nm2		= "";
	    this.car_nm3		= "";
	    this.reg_id			= "";
	    this.t_user_id		= "";
		this.t_reg_dt		= "";
		this.t_note			= "";
		this.b_note			= "";
		this.b_reg_dt		= "";
		this.est_email		= "";
		this.client_yn		= "";
		this.county			= "";
	    this.zipcode		= "";
	    this.addr1			= "";
		this.addr2			= "";
		this.account		= "";
		this.bank			= "";
		this.driver_year	= "";
		this.urgen_tel		= "";
		this.est_comp_ceo	= "";
		this.est_comp_tel	= "";
		this.est_comp_cel	= "";
		this.car_use_addr1	= "";	//�����̿����ּ�1 �߰�(2018.03.13)
		this.car_use_addr2	= "";	//�����̿����ּ�2 �߰�(2018.03.13)
		this.br_to		= "";
		this.br_to_st		= "";
		this.br_from	= "";
		this.br_from_st	= "";

	}

	// get Method
	public void setEst_id			(String val){	if(val==null) val="";	this.est_id			= val;	}
	public void setEst_st			(String val){	if(val==null) val="";	this.est_st			= val;	}
    public void setEst_nm			(String val){	if(val==null) val="";	this.est_nm			= val;	}
    public void setEst_ssn			(String val){	if(val==null) val="";	this.est_ssn		= val;	}
    public void setEst_tel			(String val){	if(val==null) val="";	this.est_tel		= val;	}
    public void setEst_fax			(String val){	if(val==null) val="";	this.est_fax		= val;	}
    public void setEst_agnt			(String val){	if(val==null) val="";	this.est_agnt		= val;	}
    public void setEst_bus			(String val){	if(val==null) val="";	this.est_bus		= val;	}
	public void setEst_year			(String val){	if(val==null) val="";	this.est_year		= val;	}
	public void setCar_nm			(String val){	if(val==null) val="";	this.car_nm			= val;	}
	public void setEtc				(String val){	if(val==null) val="";	this.etc			= val;	}
	public void setReg_dt			(String val){	if(val==null) val="";	this.reg_dt			= val;	}
	public void setM_user_id		(String val){	if(val==null) val="";	this.m_user_id		= val;	}
	public void setM_reg_dt			(String val){	if(val==null) val="";	this.m_reg_dt		= val;	}
	public void setRent_yn			(String val){	if(val==null) val="";	this.rent_yn		= val;	}
	public void setEst_area			(String val){	if(val==null) val="";	this.est_area		= val;	}
	public void setEst_gubun		(String val){	if(val==null) val="";	this.est_gubun		= val;	}
	public void setCar_nm2			(String val){	if(val==null) val="";	this.car_nm2		= val;	}
	public void setCar_nm3			(String val){	if(val==null) val="";	this.car_nm3		= val;	}
	public void setReg_id			(String val){	if(val==null) val="";	this.reg_id			= val;	}
	public void setT_user_id		(String val){	if(val==null) val="";	this.t_user_id		= val;	}
	public void setT_reg_dt			(String val){	if(val==null) val="";	this.t_reg_dt		= val;	}
	public void setT_note			(String val){	if(val==null) val="";	this.t_note			= val;	}
	public void setB_note			(String val){	if(val==null) val="";	this.b_note			= val;	}
	public void setB_reg_dt			(String val){	if(val==null) val="";	this.b_reg_dt		= val;	}
	public void setEst_email		(String val){	if(val==null) val="";	this.est_email		= val;	}
	public void setClient_yn		(String val){	if(val==null) val="";	this.client_yn		= val;	}
	public void setCounty			(String val){	if(val==null) val="";	this.county			= val;	}
	public void setZipcode			(String val){	if(val==null) val="";	this.zipcode		= val;	}
	public void setAddr1			(String val){	if(val==null) val="";	this.addr1			= val;	}
	public void setAddr2			(String val){	if(val==null) val="";	this.addr2			= val;	}
	public void setAccount			(String val){	if(val==null) val="";	this.account		= val;	}
	public void setBank				(String val){	if(val==null) val="";	this.bank			= val;	}
	public void setDriver_year		(String val){	if(val==null) val="";	this.driver_year	= val;	}
	public void setUrgen_tel		(String val){	if(val==null) val="";	this.urgen_tel		= val;	}
	public void setEst_comp_ceo		(String val){	if(val==null) val="";	this.est_comp_ceo	= val;	}
	public void setEst_comp_tel		(String val){	if(val==null) val="";	this.est_comp_tel	= val;	}
	public void setEst_comp_cel		(String val){	if(val==null) val="";	this.est_comp_cel	= val;	}
	public void setCar_use_addr1	(String val){	if(val==null) val="";	this.car_use_addr1	= val;	}	//�����̿����ּ�1 �߰�(2018.03.13)
	public void setCar_use_addr2	(String val){	if(val==null) val="";	this.car_use_addr2	= val;	}	//�����̿����ּ�2 �߰�(2018.03.13)
	public void setBr_to		(String val){	if(val==null) val="";	this.br_to		= val;	}
	public void setBr_to_st		(String val){	if(val==null) val="";	this.br_to_st		= val;	}
	public void setBr_from	(String val){	if(val==null) val="";	this.br_from	= val;	}
	public void setBr_from_st	(String val){	if(val==null) val="";	this.br_from_st	= val;	}

	//Get Method
	public String getEst_id			(){		return est_id;			}
	public String getEst_st			(){		return est_st;			}
	public String getEst_nm			(){		return est_nm;			}
    public String getEst_ssn		(){		return est_ssn;			}
    public String getEst_tel		(){		return est_tel;			}
    public String getEst_fax		(){		return est_fax;			}
    public String getEst_agnt		(){		return est_agnt;		}
    public String getEst_bus		(){		return est_bus;			}
    public String getEst_year		(){		return est_year;		}
    public String getCar_nm			(){		return car_nm;			}
    public String getEtc			(){		return etc;				}
    public String getReg_dt			(){		return reg_dt;			}
    public String getM_user_id		(){		return m_user_id;		}
    public String getM_reg_dt		(){		return m_reg_dt;		}
    public String getRent_yn		(){		return rent_yn;			}
    public String getEst_area		(){		return est_area;		}
    public String getEst_gubun		(){		return est_gubun;		}
    public String getCar_nm2		(){		return car_nm2;			}
    public String getCar_nm3		(){		return car_nm3;			}    
    public String getReg_id			(){		return reg_id;			}
	public String getT_user_id		(){		return t_user_id;		}
    public String getT_reg_dt		(){		return t_reg_dt;		}
    public String getT_note			(){		return t_note;			}
    public String getB_note			(){		return b_note;			}
    public String getB_reg_dt		(){		return b_reg_dt;		}
	public String getEst_email		(){		return est_email;		}
	public String getClient_yn		(){		return client_yn;		}
   	public String getCounty			(){		return county;			}
	public String getZipcode		(){		return zipcode;			}
    public String getAddr1			(){		return addr1;			}
    public String getAddr2			(){		return addr2;			}
    public String getAccount		(){		return account;			}
    public String getBank			(){		return bank;			}
	public String getDriver_year	(){		return driver_year;		}
	public String getUrgen_tel		(){		return urgen_tel;		}
	public String getEst_comp_ceo	(){		return est_comp_ceo;	}
	public String getEst_comp_tel	(){		return est_comp_tel;	}
	public String getEst_comp_cel	(){		return est_comp_cel;	}
	public String getCar_use_addr1	(){		return car_use_addr1;	}	//�����̿����ּ�1 �߰�(2018.03.13)
	public String getCar_use_addr2	(){		return car_use_addr2;	}	//�����̿����ּ�2 �߰�(2018.03.13)
	public String getBr_to	(){		return br_to;	}
	public String getBr_to_st	(){		return br_to_st;	}
	public String getBr_from(){		return br_from;	}
	public String getBr_from_st(){		return br_from_st;	}

}	

