// �ܱ��� �뿪��� ������ ����

// �ۼ��� : 2003.12.11 (������)

package acar.res_search;

public class ScdDrivBean
{
	private String rent_s_cd;		//�ܱ��������ȣ
	private String rent_st;			//����:�Ա�,��Ÿ
	private String tm;				//ȸ��
	private String paid_st;			//�Աݼ���:ī��,����,��ü
	private int pay_amt;			//�ݾ�
	private String pay_dt;			//�Ա�����
	private String reg_id;			//�����
	private String reg_dt;			//�����
	private String update_id;		//������
	private String update_dt;		//������
	
	public ScdDrivBean()
	{
		rent_s_cd	= "";    
		rent_st = "";    
		tm = "";    
		paid_st = "";
		pay_amt = 0;
		pay_dt = "";  
		reg_dt = "";    
		reg_id = "";    
		update_dt = "";    
		update_id = "";    
	}
	
	public void setRent_s_cd(String str) 	{ rent_s_cd		= str; }
	public void setRent_st(String str)		{ rent_st		= str; }    	
	public void setTm(String str)			{ tm			= str; }		
	public void setPaid_st(String str)		{ paid_st		= str; }    
	public void setPay_amt(int i)			{ pay_amt		= i;   }    
	public void setPay_dt(String str)		{ pay_dt		= str; }      
	public void setReg_dt(String str)		{ reg_dt		= str; }    
	public void setReg_id(String str)		{ reg_id		= str; }    
	public void setUpdate_dt(String str)	{ update_dt		= str; }    
	public void setUpdate_id(String str)	{ update_id		= str; }    

	public String getRent_s_cd() 	{ return rent_s_cd;		}
	public String getRent_st()		{ return rent_st;		}
	public String getTm()			{ return tm;			}
	public String getPaid_st()		{ return paid_st;		}
	public int getPay_amt()			{ return pay_amt;		}
	public String getPay_dt()		{ return pay_dt;		}
	public String getReg_dt()		{ return reg_dt;		}
	public String getReg_id()		{ return reg_id;		}
	public String getUpdate_dt()	{ return update_dt;		}
	public String getUpdate_id()	{ return update_id;		}

}