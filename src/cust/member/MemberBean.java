// ��FMS ȸ������

// �ۼ��� : 2004.05.17 (������)

package cust.member;

public class MemberBean
{
	private String idx;				//�Ϸù�ȣ
	private String client_id;		//����ȣ
	private String r_site;			//��뺻������ȣ
	private String member_id;		//�α��ξ��̵�
	private String pwd;				//�α��κ�й�ȣ
	private String use_yn;			//��뿩��(Y/N)
	private String email;			//�̸���
	private String reg_dt;			//�����
	private String update_dt;		//������
	private String firm_nm;			//��ȣ��
	private String client_nm;		//����ڸ�
	private String r_site_nm;		//��뺻������
	
	public MemberBean()
	{
		idx	= "";        
		client_id	= "";    
		r_site = "";    
		member_id = "";
		pwd = "";
		use_yn = "";
		email = "";
		reg_dt = "";
		update_dt = "";
		firm_nm = "";
		client_nm = "";
		r_site_nm = "";
	}
	
	public void setIdx(String str)			{ idx			= str; }    
	public void setClient_id(String str) 	{ client_id		= str; }
	public void setR_site(String str)		{ r_site		= str; }    	
	public void setMember_id(String str)	{ member_id		= str; }    	
	public void setPwd(String str)			{ pwd			= str; }    	
	public void setUse_yn(String str)		{ use_yn		= str; }    	
	public void setEmail(String str)		{ email			= str; }    	
	public void setReg_dt(String str)		{ reg_dt		= str; }    
	public void setUpdate_dt(String str)	{ update_dt		= str; }    
	public void setFirm_nm(String str)		{ firm_nm		= str; }
	public void setClient_nm(String str)	{ client_nm		= str; }
	public void setR_site_nm(String str)	{ r_site_nm		= str; }	

	public String getIdx()			{ return idx;			}
	public String getClient_id() 	{ return client_id;		}
	public String getR_site()		{ return r_site;		}
	public String getMember_id()	{ return member_id;		}
	public String getPwd()			{ return pwd;			}
	public String getUse_yn()		{ return use_yn;		}
	public String getEmail()		{ return email;			}
	public String getReg_dt()		{ return reg_dt;		}
	public String getUpdate_dt()	{ return update_dt;		}
	public String getFirm_nm() 		{ return firm_nm;		}
	public String getClient_nm() 	{ return client_nm;		}
	public String getR_site_nm() 	{ return r_site_nm;		}

}