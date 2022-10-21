/**
 * �ڵ���������
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_office;

import java.util.*;

public class CarOffBean {
    //Table : CAR_OFF
    private String car_off_id;					//������ID
    private String car_comp_id;					//�ڵ���ȸ��ID
    private String car_comp_nm;					//�ڵ���ȸ���̸�
    private String car_off_nm;					//�����Ҹ�
    private String car_off_st;					//�����ұ���
    private String owner_nm;					//������
    private String car_off_tel;					//�繫����ȭ
    private String car_off_fax;					//�ѽ�
    private String car_off_post;				//�����ȣ
    private String car_off_addr;				//�ּ�
    private String bank;						//���°�������
    private String acc_no;						//���¹�ȣ
    private String acc_nm;						//������
    private String use_yn;						//���翩��
    private String ven_code;					//�׿����ŷ�ó�ڵ�
	private String one_self_yn;					//��ü������ҿ���
	private String manager;						//����
	private String agnt_nm;						//���ǹ���
	private String agnt_m_tel;					//���ǹ����ڵ���
	private String enp_no;						//���ǹ����ڵ���
	private String reg_id;						//�����
	private String reg_dt;						//�����
	private String agent_st;					//�Ҽӱ���
	private String enp_st;						//����ڱ���
	private String enp_reg_st;					//����ڵ�ϱ���
	private String doc_st;						//��������
	private String est_day;						//���޿�����
	private String req_st;						//���뿩��
	private String pay_st;						//���ޱ���
	private String agnt_email;					//���ǹ��ڸ���
	private String work_st;						//��������
	private String est_mon_st;					//���޿�����(�Ϳ�,���)
	private String bank_cd;				

        
    // CONSTRCTOR            
    public CarOffBean() {  
    	this.car_off_id		= "";
	    this.car_comp_id	= "";
	    this.car_comp_nm	= "";
	    this.car_off_nm		= "";
	    this.car_off_st		= "";
	    this.owner_nm		= "";
	    this.car_off_tel	= "";
	    this.car_off_fax	= "";
	    this.car_off_post	= "";
	    this.car_off_addr	= "";
	    this.bank			= "";
	    this.acc_no			= "";
	    this.acc_nm			= "";
	    this.use_yn			= "";
	    this.ven_code		= "";
	    this.one_self_yn	= "";
	    this.manager		= "";
	    this.agnt_nm		= "";
	    this.agnt_m_tel		= "";
		this.enp_no			= "";
	    this.reg_id			= "";
	    this.reg_dt			= "";
	    this.agent_st		= "";
	    this.enp_st			= "";
	    this.enp_reg_st		= "";
	    this.doc_st			= "";
	    this.est_day		= "";
	    this.req_st			= "";
		this.pay_st			= "";
		this.agnt_email		= "";
		this.work_st		= "";
		this.est_mon_st		= "";
		this.bank_cd		= "";


	}

	// get Method
	public void setCar_off_id	(String val){		if(val==null) val="";		this.car_off_id		= val;	}
	public void setCar_comp_id	(String val){		if(val==null) val="";		this.car_comp_id	= val;	}
	public void setCar_comp_nm	(String val){		if(val==null) val="";		this.car_comp_nm	= val;	}
	public void setCar_off_nm	(String val){		if(val==null) val="";		this.car_off_nm		= val;	}
	public void setCar_off_st	(String val){		if(val==null) val="";		this.car_off_st		= val;	}
	public void setOwner_nm		(String val){		if(val==null) val="";		this.owner_nm		= val;	}
	public void setCar_off_tel	(String val){		if(val==null) val="";		this.car_off_tel	= val;	}
	public void setCar_off_fax	(String val){		if(val==null) val="";		this.car_off_fax	= val;	}
	public void setCar_off_post	(String val){		if(val==null) val="";		this.car_off_post	= val;	}
	public void setCar_off_addr	(String val){		if(val==null) val="";		this.car_off_addr	= val;	}
	public void setBank			(String val){		if(val==null) val="";		this.bank			= val;	}
	public void setAcc_no		(String val){		if(val==null) val="";		this.acc_no			= val;	}
	public void setAcc_nm		(String val){		if(val==null) val="";		this.acc_nm			= val;	}
	public void setUse_yn		(String val){		if(val==null) val="";		this.use_yn			= val;	}
	public void setVen_code		(String val){		if(val==null) val="";		this.ven_code		= val;	}
	public void setOne_self_yn	(String val){		if(val==null) val="";		this.one_self_yn	= val;	}
	public void setManager		(String val){		if(val==null) val="";		this.manager		= val;	}
	public void setAgnt_nm		(String val){		if(val==null) val="";		this.agnt_nm		= val;	}
	public void setAgnt_m_tel	(String val){		if(val==null) val="";		this.agnt_m_tel		= val;	}
	public void setEnp_no		(String val){		if(val==null) val="";		this.enp_no			= val;	}
	public void setReg_id		(String val){		if(val==null) val="";		this.reg_id			= val;	}
	public void setReg_dt		(String val){		if(val==null) val="";		this.reg_dt			= val;	}
	public void setAgent_st		(String val){		if(val==null) val="";		this.agent_st		= val;	}
	public void setEnp_st		(String val){		if(val==null) val="";		this.enp_st			= val;	}
	public void setEnp_reg_st	(String val){		if(val==null) val="";		this.enp_reg_st		= val;	}
	public void setDoc_st		(String val){		if(val==null) val="";		this.doc_st			= val;	}
	public void setEst_day		(String val){		if(val==null) val="";		this.est_day		= val;	}
	public void setReq_st		(String val){		if(val==null) val="";		this.req_st			= val;	}
	public void setPay_st		(String val){		if(val==null) val="";		this.pay_st			= val;	}
	public void setAgnt_email	(String val){		if(val==null) val="";		this.agnt_email		= val;	}
	public void setWork_st		(String val){		if(val==null) val="";		this.work_st		= val;	}
	public void setEst_mon_st	(String val){		if(val==null) val="";		this.est_mon_st		= val;	}
	public void setBank_cd		(String val){		if(val==null) val="";		this.bank_cd		= val;	}

	//Get Method
	public String getCar_off_id		(){		return car_off_id;		}
	public String getCar_comp_id	(){		return car_comp_id;		}
	public String getCar_comp_nm	(){		return car_comp_nm;		}
	public String getCar_off_nm		(){		return car_off_nm;		}
	public String getCar_off_st		(){		return car_off_st;		}
	public String getOwner_nm		(){		return owner_nm;		}
	public String getCar_off_tel	(){		return car_off_tel;		}
	public String getCar_off_fax	(){		return car_off_fax;		}
	public String getCar_off_post	(){		return car_off_post;	}
	public String getCar_off_addr	(){		return car_off_addr;	}
	public String getBank			(){		return bank;			}
	public String getAcc_no			(){		return acc_no;			}
	public String getAcc_nm			(){		return acc_nm;			}
	public String getUse_yn			(){		return use_yn;			}
	public String getVen_code		(){		return ven_code;		}
	public String getOne_self_yn	(){		return one_self_yn;		}
	public String getManager		(){		return manager;			}
	public String getAgnt_nm		(){		return agnt_nm;			}
	public String getAgnt_m_tel		(){		return agnt_m_tel;		}
	public String getEnp_no			(){		return enp_no;			}
	public String getReg_id			(){		return reg_id;			}
	public String getReg_dt			(){		return reg_dt;			}
	public String getAgent_st		(){		return agent_st;		}
	public String getEnp_st			(){		return enp_st;			}
	public String getEnp_reg_st		(){		return enp_reg_st;		}
	public String getDoc_st			(){		return doc_st;			}
	public String getEst_day		(){		return est_day;			}
	public String getReq_st			(){		return req_st;			}
	public String getPay_st			(){		return pay_st;			}
	public String getAgnt_email		(){		return agnt_email;		}
	public String getWork_st		(){		return work_st;			}
	public String getEst_mon_st		(){		return est_mon_st;		}
	public String getBank_cd		(){		return bank_cd;			}

}