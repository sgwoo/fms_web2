/**
 * ���޼�����
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_office;

import java.util.*;

public class CarOffEmpBean {
    //Table : COMMI
    private String rent_mng_id; 				//��������ȣ
	private String emp_id;						//�������ID
    private String car_off_id;					//������ID
    private String car_off_nm;					//�����Ҹ�Ī
    private String car_off_st;					//�����ұ���
    private String owner_nm;
    private String car_comp_id;					//�ڵ���ȸ��ID
    private String car_comp_nm;					//�ڵ���ȸ�� ��Ī
    private String cust_st;						//������
    private String emp_nm;						//����
    private String emp_ssn;						//�ֹε�Ϲ�ȣ
    private String emp_ssn1;						//�ֹε�Ϲ�ȣ
    private String emp_ssn2;						//�ֹε�Ϲ�ȣ
    private String car_off_tel;					//�繫����ȭ
	private String car_off_fax;					//�ѽ�
    private String emp_m_tel;					//�ڵ���
    private String emp_pos;						//����
    private String emp_email;					//�̸���
    private String emp_bank;					//����
    private String emp_acc_no;					//���¹�ȣ
    private String emp_acc_nm;					//������
    private String emp_post;
    private String emp_addr;
	private String etc;							//���
	private String car_off_post;				//�����ҿ����ȣ
	private String car_off_addr;				//�������ּ�
	private String reg_dt;
	private String reg_id;
	private String upd_dt;
	private String upd_id;
	private String emp_h_tel;					//�������-����ȭ
	private String emp_sex;						//�������-����
	private String use_yn;						//sms���ڼ��ſ���
	private String sms_denial_rsn;				//sms���ڼ��Űźλ���
	private String seq;							//����ں������
	private String damdang_id;					//�����
	private String cng_rsn;						//����� ��������
	private String cng_dt;						//��� ����(����)����
	private String file_name1;					//��ĵ����-�ź���
	private String file_name2;					//��ĵ����-����
	private String job_st;						//20080228
	private String file_gubun1;					//��ĵ����-�ź���
	private String file_gubun2;					//��ĵ����-����
	private String one_self_yn;					//��ü������ҿ���
	private String agent_id;					//������Ʈ�ڵ�
	private String emp_dept;					//�μ�
	private String fraud_care;					//���ŷ� ���� ���ǿ��
	private String bank_cd;					

        
    // CONSTRCTOR            
    public CarOffEmpBean() {  
		this.rent_mng_id	= ""; 					//��������ȣ
		this.emp_id			= "";					//�������ID
	    this.car_off_id		= "";					//������ID
	    this.car_off_nm		= "";					//�����Ҹ�Ī
	    this.car_off_st		= "";					
	    this.owner_nm		= "";
	    this.car_comp_id	= "";					//�ڵ���ȸ��ID
	    this.car_comp_nm	= "";					//�ڵ���ȸ�� ��Ī
	    this.cust_st		= "";					//������
	    this.emp_nm			= "";					//����
	    this.emp_ssn		= "";					//�ֹε�Ϲ�ȣ
	    this.emp_ssn1		= "";					//�ֹε�Ϲ�ȣ
	    this.emp_ssn2		= "";					//�ֹε�Ϲ�ȣ
	    this.car_off_tel	= "";					//�繫����ȭ
		this.car_off_fax	= "";					//�ѽ�
	    this.emp_m_tel		= "";					//�ڵ���
	    this.emp_pos		= "";					//����
	    this.emp_email		= "";					//�̸���
	    this.emp_bank		= "";					//����
	    this.emp_acc_no		= "";					//���¹�ȣ
	    this.emp_acc_nm		= "";					//������
	    this.emp_post		= "";						
	    this.emp_addr		= "";						
		this.etc			= "";
		this.car_off_post	= "";					//������ �����ȣ   
		this.car_off_addr	= "";					//������ �ּ�
		this.reg_dt			= "";
		this.reg_id			= "";
		this.upd_dt			= "";
		this.upd_id			= "";
		this.emp_h_tel		= "";
		this.emp_sex		= "";
		this.use_yn			= "";
		this.sms_denial_rsn = "";
		this.seq			= "";
		this.damdang_id		= "";
		this.cng_rsn		= "";
		this.cng_dt			= "";
		this.file_name1		= "";
		this.file_name2		= "";
		this.job_st 		= "";
		this.file_gubun1	= "";
		this.file_gubun2	= "";
		this.one_self_yn	= "";
		this.agent_id		= "";
		this.emp_dept		= "";
		this.fraud_care     = "";
		this.bank_cd		= "";

	}

	// get Method
	public void setRent_mng_id		(String val){		if(val==null) val="";		this.rent_mng_id	= val;	}
	public void setEmp_id			(String val){		if(val==null) val="";		this.emp_id			= val;	}
	public void setCar_off_id		(String val){		if(val==null) val="";		this.car_off_id		= val;	}
	public void setCar_off_nm		(String val){		if(val==null) val="";		this.car_off_nm		= val;	}
	public void setCar_off_st		(String val){		if(val==null) val="";		this.car_off_st		= val;	}
	public void setOwner_nm			(String val){		if(val==null) val="";		this.owner_nm		= val;	}
	public void setCar_comp_id		(String val){		if(val==null) val="";		this.car_comp_id	= val;	}
	public void setCar_comp_nm		(String val){		if(val==null) val="";		this.car_comp_nm	= val;	}
	public void setCust_st			(String val){		if(val==null) val="";		this.cust_st		= val;	}
	public void setEmp_nm			(String val){		if(val==null) val="";		this.emp_nm			= val;	}
	public void setEmp_ssn			(String val){		if(val==null) val="";		this.emp_ssn		= val;	}
	public void setCar_off_tel		(String val){		if(val==null) val="";		this.car_off_tel	= val;	}
	public void setCar_off_fax		(String val){		if(val==null) val="";		this.car_off_fax	= val;	}
	public void setEmp_m_tel		(String val){		if(val==null) val="";		this.emp_m_tel		= val;	}
	public void setEmp_pos			(String val){		if(val==null) val="";		this.emp_pos		= val;	}
	public void setEmp_email		(String val){		if(val==null) val="";		this.emp_email		= val;	}
	public void setEmp_bank			(String val){		if(val==null) val="";		this.emp_bank		= val;	}
	public void setEmp_acc_no		(String val){		if(val==null) val="";		this.emp_acc_no		= val;	}
	public void setEmp_acc_nm		(String val){		if(val==null) val="";		this.emp_acc_nm		= val;	}
	public void setEmp_post			(String val){		if(val==null) val="";		this.emp_post		= val;	}
	public void setEmp_addr			(String val){		if(val==null) val="";		this.emp_addr		= val;	}
	public void setEtc				(String val){		if(val==null) val="";		this.etc			= val;	}
	public void setCar_off_post		(String val){		if(val==null) val="";		this.car_off_post	= val;	}
	public void setCar_off_addr		(String val){		if(val==null) val="";		this.car_off_addr	= val;	}
	public void setReg_dt			(String val){		if(val==null) val="";		this.reg_dt			= val;	}
	public void setReg_id			(String val){		if(val==null) val="";		this.reg_id			= val;	}
	public void setUpd_dt			(String val){		if(val==null) val="";		this.upd_dt			= val;	}
	public void setUpd_id			(String val){		if(val==null) val="";		this.upd_id			= val;	}
	public void setEmp_h_tel		(String val){		if(val==null) val="";		this.emp_h_tel		= val;	}
	public void setEmp_sex			(String val){		if(val==null) val="";		this.emp_sex		= val;	}
	public void setUse_yn			(String val){		if(val==null) val="";		this.use_yn			= val;	}
	public void setSms_denial_rsn	(String val){		if(val==null) val="";		this.sms_denial_rsn = val;	}
	public void setSeq				(String val){		if(val==null) val="";		this.seq			= val;	}
	public void setDamdang_id		(String val){		if(val==null) val="";		this.damdang_id		= val;	}
	public void setCng_rsn			(String val){		if(val==null) val="";		this.cng_rsn		= val;	}
	public void setCng_dt			(String val){		if(val==null) val="";		this.cng_dt			= val;	}
	public void setFile_name1		(String val){		if(val==null) val="";		this.file_name1		= val;	}
	public void setFile_name2		(String val){		if(val==null) val="";		this.file_name2		= val;	}
	public void setFile_gubun1		(String val){		if(val==null) val="";		this.file_gubun1	= val;	}
	public void setFile_gubun2		(String val){		if(val==null) val="";		this.file_gubun2	= val;	}
	public void setJob_st		 	(String val){		if(val==null) val="";		this.job_st	 	  	= val;	}
	public void setOne_self_yn		(String val){		if(val==null) val="";		this.one_self_yn	= val;	}
	public void setAgent_id			(String val){		if(val==null) val="";		this.agent_id		= val;	}
	public void setEmp_dept			(String val){		if(val==null) val="";		this.emp_dept		= val;	}
	public void setFraud_care		(String val){		if(val==null) val="";		this.fraud_care		= val;	}
	public void setBank_cd			(String val){		if(val==null) val="";		this.bank_cd		= val;	}
	
		
	//Get Method
	public String getRent_mng_id	(){		return rent_mng_id;		}
	public String getEmp_id			(){		return emp_id;			}
	public String getCar_off_id		(){		return car_off_id;		}
	public String getCar_off_nm		(){		return car_off_nm;		}
	public String getCar_off_st		(){		return car_off_st;		}
	public String getOwner_nm		(){		return owner_nm;		}
	public String getCar_comp_id	(){		return car_comp_id;		}
	public String getCar_comp_nm	(){		return car_comp_nm;		}
	public String getCust_st		(){		return cust_st;			}
	public String getEmp_nm			(){		return emp_nm;			}
	public String getEmp_ssn		(){		return emp_ssn;			}
	public String getCar_off_tel	(){		return car_off_tel;		}
	public String getCar_off_fax	(){		return car_off_fax;		}
	public String getEmp_m_tel		(){		return emp_m_tel;		}
	public String getEmp_pos		(){		return emp_pos;			}
	public String getEmp_email		(){		return emp_email;		}
	public String getEmp_bank		(){		return emp_bank;		}
	public String getEmp_acc_no		(){		return emp_acc_no;		}
	public String getEmp_acc_nm		(){		return emp_acc_nm;		}
	public String getEmp_post		(){		return emp_post;		}
	public String getEmp_addr		(){		return emp_addr;		}
	public String getEtc			(){		return etc;				}
	public String getCar_off_post	(){		return car_off_post;	}
	public String getCar_off_addr	(){		return car_off_addr;	}
	public String getReg_dt			(){		return reg_dt;			}
	public String getReg_id			(){		return reg_id;			}
	public String getUpd_dt			(){		return upd_dt;			}
	public String getUpd_id			(){		return upd_id;			}
	public String getEmp_h_tel		(){		return emp_h_tel;		}
	public String getEmp_sex		(){		return emp_sex;			}
	public String getUse_yn			(){		return use_yn;			}
	public String getSms_denial_rsn	(){		return sms_denial_rsn;	}
	public String getSeq			(){		return seq;				}
	public String getDamdang_id		(){		return damdang_id;		}
	public String getCng_rsn		(){		return cng_rsn;			}
	public String getCng_dt			(){		return cng_dt;			}
	public String getFile_name1		(){		return file_name1;		}
	public String getFile_name2		(){		return file_name2;		}
	public String getJob_st		   	(){		return job_st;		   	}  
	public String getFile_gubun1	(){		return file_gubun1;		}
	public String getFile_gubun2	(){		return file_gubun2;		}
	public String getOne_self_yn	(){		return one_self_yn;		}
	public String getAgent_id		(){		return agent_id;		}
	public String getEmp_dept		(){		return emp_dept;		}
	public String getFraud_care		(){		return fraud_care;		}
	public String getBank_cd		(){		return bank_cd;			}
	

	public String getEmp_ssn1		(){
		if(emp_ssn.equals("")){
			return emp_ssn1;
		}else{
			if(emp_ssn.length()>6){
				return emp_ssn.substring(0,6);	
			}else{
				return emp_ssn1;	
			}
		}
	}
	public String getEmp_ssn2		(){
		if(emp_ssn.equals("")){
			return emp_ssn2;
		}else{
			if(emp_ssn.length()>6){	
				return emp_ssn.substring(6);
			}else{
				return emp_ssn2;
			}
		}
	}

}
