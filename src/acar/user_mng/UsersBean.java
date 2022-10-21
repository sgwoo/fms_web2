/*
 * ����ڰ���
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.user_mng;

import java.util.*;

public class UsersBean {
    //Table : USERS
    private String user_id;					//����ڰ�����ȣ
    private String br_id;					// ����ID
    private String br_nm;					//������Ī
    private String user_nm;					//������̸�
    private String id;						//�����ID
    private String user_psd;				//��й�ȣ
    private String user_ssn;				//�ֹε�Ϲ�ȣ
    private String user_ssn1;
    private String user_ssn2;
    private String user_cd;					//�����ȣ
    private String dept_id;					//�μ�ID
    private String dept_nm;					//�μ��̸�
    private String user_h_tel;				//����ȭ��ȣ
    private String user_m_tel;				//�޴���
    private String user_email;				//�̸���
    private String user_pos;				//����
    private String user_aut;				//����	
	private String lic_no;					//���������ȣ
	private String lic_dt;					//�����ȣ	
	private String enter_dt;				//�Ի�����
	private String content;					//�λ縻
	private String filename;				//����
	private String filename2;				//����
	private String zip;						//�����ȣ
	private String addr;					//�ּ�
    private String use_yn;					//�ٹ�����
	private String mail_id;					//�̸��Ͼ��̵�
    private String mail_pw;					//�̸��Ϻ�й�ȣ
    private String sa_code;					//�׳뿥����ڵ�
    private String out_dt;					//�������
    private String loan_st;					//ä��bit - 1:1�� 2:2��
    private String user_work;				//������
    private String user_i_tel;				//�������ͳݻ���ڹ�ȣ
    private String fax_id;					//���ͳ��ѽ����̵�
    private String fax_pw;					//���ͳ��ѽ���й�ȣ
    private String partner_id;				//ä����Ʈ�ʾ��̵�
	private String i_fax;					//�׿������ѽ����Ź�ȣ
	private String in_tel;					//������ȣ
	private String hot_tel;					//������ȭ
	private String taste;					//���
	private String special;					//Ư��
	private String ven_code;				//�׿��� �ŷ�ó�ڵ�
	private String gundea;					//���ʿ���
	private String bank_nm;					//����
	private String bank_no;					//���¹�ȣ
	private String m_io;					//���� �޼��� �ޱ� ��� :Y-���, ����-���
	private String user_group;				//ī����ǥ��Ͻ� ��Ʈ�� �׷�
	private float  add_per;					//ä����Ʈ�ʰ�����
	private String area_id;					//�ٹ���ID
	private String area_nm;					//�ٹ�����
	private String home_zip;				//�ǰ����� �����ȣ
	private String home_addr;				//�ǰ����� �ּ�
	private String sch_chk;					//�ް�����
	private String age;						//����
	private String dept_out;				//��� ���� �ٹ��μ�
	private String user_job;				//��å
	private String agent_cont_view;			//������Ʈ�����ȸ����
	private String ars_group;				//ARS��Ʈ��
	
    // CONSTRCTOR            
    public UsersBean() {  
    	this.user_id	= "";				//����ڰ�����ȣ
	    this.br_id		= "";				// ����ID
	    this.br_nm		= "";				//������Ī
	    this.user_nm	= "";				//������̸�
	    this.id			= "";				//�����ID
	    this.user_psd	= "";				//��й�ȣ
	    this.user_ssn	= "";				//�ֹε�Ϲ�ȣ
	    this.user_ssn1	= "";	
	    this.user_ssn2	= "";
	    this.user_cd	= "";				//�����ȣ
	    this.dept_id	= "";				//�μ�ID
	    this.dept_nm	= "";				//�μ��̸�
	    this.user_h_tel = "";				//����ȭ��ȣ
	    this.user_m_tel = "";				//�޴���
	    this.user_email = "";				//�̸���
	    this.user_pos	= "";				//����
	    this.user_aut	= "";				//����	
		this.lic_no		= "";
		this.lic_dt		= "";
		this.enter_dt	= "";	
		this.content	= "";
		this.filename	= "";
		this.filename2	= "";
		this.zip		= "";
		this.addr		= "";
		this.use_yn		= "";
		this.mail_id	= "";
		this.mail_pw	= "";
		this.sa_code	= "";
		this.out_dt		= "";
		this.loan_st	= "";
		this.user_work	= "";
	    this.user_i_tel = "";
		this.fax_id		= "";
		this.fax_pw		= "";
		this.partner_id = "";
		this.i_fax		= "";
		this.in_tel		= "";
		this.hot_tel	= "";
		this.taste		= "";
		this.special	= "";
		this.ven_code	= "";
		this.gundea		= "";	
		this.bank_nm	= "";	
		this.bank_no	= "";	
		this.m_io		= "";
		this.user_group = "";
		this.add_per	= 0;
		this.area_id	= "";
		this.area_nm	= "";
		this.home_zip	= "";
		this.home_addr	= "";
		this.sch_chk = "";	
		this.age = "";
		this.dept_out = "";
		this.user_job = "";
		this.agent_cont_view = "";
		this.ars_group = "";

	}

	// set Method
	public void setUser_id		(String val){		if(val==null) val="";		this.user_id	= val;	}
	public void setBr_id		(String val){		if(val==null) val="";		this.br_id		= val;	}
	public void setBr_nm		(String val){		if(val==null) val="";		this.br_nm		= val;	}
	public void setUser_nm		(String val){		if(val==null) val="";		this.user_nm	= val;	}
	public void setId			(String val){		if(val==null) val="";		this.id			= val;	}
	public void setUser_psd		(String val){		if(val==null) val="";		this.user_psd	= val;	}
	public void setUser_ssn		(String val){		if(val==null) val="";		this.user_ssn	= val;	}
	public void setUser_cd		(String val){		if(val==null) val="";		this.user_cd	= val;	}
	public void setDept_id		(String val){		if(val==null) val="";		this.dept_id	= val;	}
	public void setDept_nm		(String val){		if(val==null) val="";		this.dept_nm	= val;	}
	public void setUser_h_tel	(String val){		if(val==null) val="";		this.user_h_tel = val;	}
	public void setUser_m_tel	(String val){		if(val==null) val="";		this.user_m_tel = val;	}
	public void setIn_tel		(String val){		if(val==null) val="";		this.in_tel		= val;	}
	public void setHot_tel		(String val){		if(val==null) val="";		this.hot_tel	= val;	}	
	public void setUser_email	(String val){		if(val==null) val="";		this.user_email = val;	}
	public void setUser_pos		(String val){		if(val==null) val="";		this.user_pos	= val;	}
	public void setUser_aut		(String val){		if(val==null) val="";		this.user_aut	= val;	}
	public void setTaste		(String val){		if(val==null) val="";		this.taste		= val;	}
	public void setSpecial		(String val){		if(val==null) val="";		this.special	= val;	}
	public void setVen_code		(String val){		if(val==null) val="";		this.ven_code	= val;	}
	public void setGundea		(String val){		if(val==null) val="";		this.gundea		= val;	}
	public void setLic_no		(String val){		if(val==null) val="";		this.lic_no		= val;	}
	public void setLic_dt		(String val){		if(val==null) val="";		this.lic_dt		= val;	}	
	public void setEnter_dt		(String val){		if(val==null) val="";		this.enter_dt	= val;	}	
	public void setContent		(String val){		if(val==null) val="";		this.content	= val;	}	
	public void setFilename		(String val){		if(val==null) val="";		this.filename	= val;	}	
	public void setFilename2	(String val){		if(val==null) val="";		this.filename2	= val;	}	
	public void setZip			(String val){		if(val==null) val="";		this.zip		= val;	}	
	public void setAddr			(String val){		if(val==null) val="";		this.addr		= val;	}	
	public void setUse_yn		(String val){		if(val==null) val="";		this.use_yn		= val;	}	
	public void setMail_id		(String val){		if(val==null) val="";		this.mail_id	= val;	}	
	public void setMail_pw		(String val){		if(val==null) val="";		this.mail_pw	= val;	}	
	public void setSa_code		(String val){		if(val==null) val="";		this.sa_code	= val;	}		
	public void setOut_dt		(String val){		if(val==null) val="";		this.out_dt		= val;	}	
	public void setLoan_st		(String val){		if(val==null) val="";		this.loan_st	= val;	}	
	public void setUser_work	(String val){		if(val==null) val="";		this.user_work	= val;	}
	public void setUser_i_tel	(String val){		if(val==null) val="";		this.user_i_tel = val;	}
	public void setFax_id		(String val){		if(val==null) val="";		this.fax_id		= val;	}	
	public void setFax_pw		(String val){		if(val==null) val="";		this.fax_pw		= val;	}	
	public void setPartner_id	(String val){		if(val==null) val="";		this.partner_id = val;	}	
	public void setI_fax		(String val){		if(val==null) val="";		this.i_fax		= val;	}	
	public void setBank_nm		(String val){		if(val==null) val="";		this.bank_nm	= val;	}	
	public void setBank_no		(String val){		if(val==null) val="";		this.bank_no	= val;	}	
	public void setM_io			(String val){		if(val==null) val="";		this.m_io		= val;	}
	public void setUser_group	(String val){		if(val==null) val="";		this.user_group = val;	}
	public void setAdd_per		(float  val){									this.add_per	= val;	}
	public void setArea_id		(String val){		if(val==null) val="";		this.area_id	= val;	}	
	public void setArea_nm		(String val){		if(val==null) val="";		this.area_nm	= val;	}	
	public void setHome_zip			(String val){		if(val==null) val="";		this.home_zip		= val;	}	
	public void setHome_addr		(String val){		if(val==null) val="";		this.home_addr		= val;	}	
	public void setSch_chk(String val){		if(val==null) val="";	this.sch_chk = val;		}	
	public void setAge(String val){			if(val==null) val="";	this.age = val;			}	
	public void setDept_out(String val){			if(val==null) val="";	this.age = val;			}	
	public void setUser_job		(String val){		if(val==null) val="";		this.user_job	= val;	}
	public void setAgent_cont_view(String val){		if(val==null) val="";		this.agent_cont_view= val;	}
	public void setArs_group	(String val){		if(val==null) val="";		this.ars_group = val;	}

	
	//Get Method
	public String getUser_id	(){		return user_id;		}
	public String getBr_id		(){		return br_id;		}
	public String getBr_nm		(){		return br_nm;		}
	public String getUser_nm	(){		return user_nm;		}
	public String getId			(){		return id;			}
	public String getUser_psd	(){		return user_psd;	}
	public String getUser_ssn	(){		return user_ssn;	}
	public String getUser_ssn1	(){
		if(user_ssn.equals(""))
		{
			return user_ssn1;
		}else{
			return user_ssn.substring(0,6);
		}
	}
	public String getUser_ssn2	(){
		if(user_ssn.equals(""))
		{
			return user_ssn2;
		}else{
			return user_ssn.substring(6,13);
		}
	}
	public String getUser_cd	(){		return user_cd;		}
	public String getDept_id	(){		return dept_id;		}
	public String getDept_nm	(){		return dept_nm;		}
	public String getUser_h_tel	(){		return user_h_tel;	}
	public String getUser_m_tel	(){		return user_m_tel;	}
	public String getUser_email	(){		return user_email;	}
	public String getUser_pos	(){		return user_pos;	}
	public String getUser_aut	(){		return user_aut;	}
	public String getLic_no		(){		return lic_no;		}
	public String getLic_dt		(){		return lic_dt;		}
	public String getEnter_dt	(){		return enter_dt;	}
	public String getContent	(){		return content;		}
	public String getFilename	(){		return filename;	}
	public String getFilename2	(){		return filename2;	}
	public String getZip		(){		return zip;			}
	public String getAddr		(){		return addr;		}
	public String getUse_yn		(){		return use_yn;		}
	public String getMail_id	(){		return mail_id;		}
	public String getMail_pw	(){		return mail_pw;		}
	public String getSa_code	(){		return sa_code;		}
	public String getOut_dt		(){		return out_dt;		}
	public String getLoan_st	(){		return loan_st;		}
	public String getUser_work	(){		return user_work;	}
	public String getUser_i_tel	(){		return user_i_tel;	}
	public String getFax_id		(){		return fax_id;		}
	public String getFax_pw		(){		return fax_pw;		}
	public String getPartner_id	(){		return partner_id;	}
	public String getI_fax		(){		return i_fax;		}
	public String getIn_tel		(){		return in_tel;		}
	public String getHot_tel	(){		return hot_tel;		}
	public String getTaste		(){		return taste;		}
	public String getSpecial	(){		return special;		}
	public String getVen_code	(){		return ven_code;	}
	public String getGundea		(){		return gundea;		}
	public String getBank_nm	(){		return bank_nm;		}
	public String getBank_no	(){		return bank_no;		}
	public String getM_io		(){		return m_io;		}
	public String getUser_group	(){		return user_group;	}
	public float  getAdd_per	(){		return add_per;		}
	public String getArea_id	(){		return area_id;		}
	public String getArea_nm	(){		return area_nm;		}
	public String getHome_zip	(){		return home_zip;	}
	public String getHome_addr	(){		return home_addr;	}
	public String getSch_chk	(){		return sch_chk;		}	
	public String getAge		(){		return age;			}
	public String getDept_out	(){		return dept_out;	}
	public String getUser_job	(){		return user_job;	}
	public String getAgent_cont_view(){	return agent_cont_view;	}
	public String getArs_group	(){		return ars_group;	}
	
}