package acar.con_ins_h;

public class InsMemoBean
{
	private String rent_mng_id;	// ��������ȣ
	private String rent_l_cd;	// ����ȣ    
	private String car_mng_id;	// ����������ȣ        
	private String accid_id;    // ��������ȣ
	private String serv_id;     // ���������ȣ
	private String tm_st;		//����
	private String seq; 		// �Ϸù�ȣ
	private String reg_id;		// �ۼ���      
	private String reg_dt;		// �ۼ���      
	private String content;		// ����        
	private String speaker;		// ��ȭ��
	
	public InsMemoBean()
	{
		rent_mng_id	= "";
		rent_l_cd 	= "";
		car_mng_id 	= "";
		accid_id 	= "";
		serv_id 	= "";
		tm_st		= "";
		seq 		= "";
		reg_id 		= "";
		reg_dt 		= "";
		content 	= "";
		speaker 	= "";
	}
	
	public void setRent_mng_id(String str)	{	rent_mng_id	= str;	}
	public void setRent_l_cd(String str)	{	rent_l_cd 	= str;	}
	public void setCar_mng_id(String str)	{	car_mng_id 	= str;	}
	public void setAccid_id(String str)		{	accid_id 	= str;	}
	public void setServ_id(String str)		{	serv_id 	= str;	}
	public void setTm_st(String str)		{	tm_st 		= str;	}
	public void setSeq(String str)			{	seq 		= str;	}
	public void setReg_id(String str)		{	reg_id 		= str;	}
	public void setReg_dt(String str)		{	reg_dt 		= str;	}
	public void setContent(String str)		{	content 	= str;	}
	public void setSpeaker(String str)		{	speaker 	= str;	}
	
	public String getRent_mng_id()	{	return rent_mng_id;	}
	public String getRent_l_cd()	{	return rent_l_cd;	}
	public String getCar_mng_id()	{	return car_mng_id;	}
	public String getAccid_id()		{	return accid_id;	}
	public String getServ_id()		{	return serv_id;		}
	public String getTm_st()		{	return tm_st;		}
	public String getSeq()			{	return seq;			}
	public String getReg_id()		{	return reg_id;		}
	public String getReg_dt()		{	return reg_dt;		}
	public String getContent()		{	return content;		}
	public String getSpeaker()		{	return speaker;		}

}