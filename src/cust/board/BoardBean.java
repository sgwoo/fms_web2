// ��FMS ȸ������

// �ۼ��� : 2004.05.17 (������)

package cust.board;

public class BoardBean
{
	private String bbs_st;			//�Խ��Ǳ���(1:��������,2:������)
	private int bbs_id;				//������ȣ
	private int step;				//�ܰ�
	private int seq;				//����
	private String target;			//���(a-���,member_id)
	private String reg_id;			//�ۼ���ID
	private String reg_dt;			//�ۼ�����
	private String email;			//�̸���
	private String title;			//����
	private String content;			//����
	private int hit;				//��ȸ��
	private String user_nm;	
	private String firm_nm;	
	private int ref;
	private int re_level;
	private int re_step;
	
	public BoardBean()
	{
		bbs_st	= "";        
		bbs_id	= 0;    
		step = 0;    
		seq = 0;
		target = "";
		reg_id = "";
		reg_dt = "";
		email = "";
		title = "";
		content = "";
		hit = 0;
		user_nm = "";
		firm_nm = "";
		ref = 0;
		re_level = 0;
		re_step = 0;
	}
	
	public void setBbs_st(String str)	{ bbs_st		= str; }    
	public void setBbs_id(int i)	 	{ bbs_id		= i; }
	public void setStep(int i)			{ step			= i; }    	
	public void setSeq(int i)			{ seq			= i; }    	
	public void setTarget(String str)	{ target		= str; }    	
	public void setReg_id(String str)	{ reg_id		= str; }    	
	public void setReg_dt(String str)	{ reg_dt		= str; }    	
	public void setEmail(String str)	{ email			= str; }    	
	public void setTitle(String str)	{ title			= str; }    
	public void setContent(String str)	{ content		= str; }    
	public void setHit(int i)			{ hit			= i; }    
	public void setUser_nm(String str)	{ user_nm		= str; }    
	public void setFirm_nm(String str)	{ firm_nm		= str; }    
	public void setRef(int i)			{ ref			= i; }    
	public void setRe_level(int i)		{ re_level		= i; }    
	public void setRe_step(int i)		{ re_step		= i; }    

	public String getBbs_st()	{ return bbs_st;	}
	public int getBbs_id()		{ return bbs_id;	}
	public int getStep()		{ return step;		}
	public int getSeq()			{ return seq;		}
	public String getTarget()	{ return target;	}
	public String getReg_id()	{ return reg_id;	}
	public String getReg_dt()	{ return reg_dt;	}
	public String getEmail()	{ return email;		}
	public String getTitle()	{ return title;		}
	public String getContent()	{ return content;	}
	public int getHit() 		{ return hit;		}
	public String getUser_nm() 	{ return user_nm;	}
	public String getFirm_nm() 	{ return firm_nm;	}
	public int getRef() 		{ return ref;		}
	public int getRe_level() 	{ return re_level;	}
	public int getRe_step() 	{ return re_step;	}

}