package acar.fee;

public class FeeRtnBean
{
	//�뿩�� ����û�� ���� ���̺�

	private String rent_mng_id;		// ��������ȣ
	private String rent_l_cd;		// ����ȣ    
	private String rent_st;			// �뿩�Ϸù�ȣ        
	private String rent_seq;		// �����Ϸù�ȣ
	private String client_id;		// �ŷ�ó�����ڵ�
	private String r_site;			// �ŷ�ó�����ڵ�
	private String rtn_est_dt;		// �Աݿ�����
	private int	   rtn_amt;			// û���ݾ�
	private String rtn_move_st;		// ���࿩��(0/1)
	private String update_dt;		// ������
	private String update_id;		// ������
	private String rtn_type;		// ����
	
	public FeeRtnBean()
	{
		rent_mng_id	= "";
		rent_l_cd	= "";
		rent_st		= "";
		rent_seq	= "";
		client_id	= "";
		r_site		= "";
		rtn_est_dt	= "";
		rtn_amt		= 0;
		rtn_move_st	= "";
		update_dt	= "";
		update_id	= "";
		rtn_type	= "";
	}
	
	public void setRent_mng_id	(String str)		{	rent_mng_id	= str;	}
	public void setRent_l_cd	(String str)		{	rent_l_cd 	= str;	}
	public void setRent_st		(String str)		{	rent_st		= str;	}
	public void setRent_seq		(String str)		{	rent_seq	= str;	}
	public void setClient_id	(String str)		{	client_id	= str;	}
	public void setR_site		(String str)		{	r_site		= str;	}
	public void setRtn_est_dt	(String str)		{	rtn_est_dt	= str;	}
	public void setRtn_amt		(int str)			{	rtn_amt		= str;	}
	public void setRtn_move_st	(String str)		{	rtn_move_st	= str;	}
	public void setUpdate_dt	(String str)		{	update_dt	= str;	}
	public void setUpdate_id	(String str)		{	update_id	= str;	}
	public void setRtn_type		(String str)		{	rtn_type	= str;	}
	
	public String getRent_mng_id()		{	return rent_mng_id;	}
	public String getRent_l_cd	()		{	return rent_l_cd;	}
	public String getRent_st	()		{	return rent_st;		}
	public String getRent_seq	()		{	return rent_seq;	}
	public String getClient_id	()		{	return client_id;	}
	public String getR_site		()		{	return r_site;		}
	public String getRtn_est_dt	()		{	return rtn_est_dt;	}
	public int    getRtn_amt	()		{	return rtn_amt;		}
	public String getRtn_move_st()		{	return rtn_move_st;	}
	public String getUpdate_dt	()		{	return update_dt;	}
	public String getUpdate_id	()		{	return update_id;	}
	public String getRtn_type	()		{	return rtn_type;	}

}
