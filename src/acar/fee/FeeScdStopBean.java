package acar.fee;

public class FeeScdStopBean
{
	//���ݰ�꼭 ���� �Ͻ����� ���� ���̺�

	private String rent_mng_id;		// ��������ȣ
	private String rent_l_cd;		// ����ȣ    
	private String seq;				// �Ϸù�ȣ        
	private String stop_st;			// ��������:��ü-1, ����û-2
	private String stop_s_dt;		// �����Ⱓ
	private String stop_e_dt;		// �����Ⱓ        
	private String stop_cau;		// ��������        
	private String stop_doc_dt;		// ��������߽�����
	private String stop_doc;		// ��������ĵ���ϸ�        
	private String stop_tax_dt;		// �ϰ���������(����û�� �б⳻ ���������ڿ� �ϰ��ڵ�������)        
	private String reg_dt;			// �����      
	private String reg_id;			// �����      
	private String cancel_dt;		// ��������        
	private String cancel_id;		// ���������        
	private String doc_id;			// ���������    
	private String rent_seq;		// �����Ϸù�ȣ
	private String firm_nm;			// ���Ұ�
	
	public FeeScdStopBean()
	{
		rent_mng_id	= "";
		rent_l_cd 	= "";
		seq 		= "";
		stop_st 	= "";
		stop_s_dt 	= "";
		stop_e_dt 	= "";
		stop_cau 	= "";
		stop_doc_dt	= "";
		stop_doc 	= "";
		stop_tax_dt	= "";
		reg_dt 		= "";
		reg_id 		= "";
		cancel_dt 	= "";
		cancel_id 	= "";
		doc_id		= "";
		rent_seq	= "";
		firm_nm		= "";
	}
	
	public void setRent_mng_id	(String str)		{	rent_mng_id	= str;	}
	public void setRent_l_cd	(String str)		{	rent_l_cd 	= str;	}
	public void setSeq 			(String str)		{	seq 		= str;	}
	public void setStop_st 		(String str)		{	stop_st 	= str;	}
	public void setStop_s_dt	(String str)		{	stop_s_dt 	= str;	}
	public void setStop_e_dt	(String str)		{	stop_e_dt 	= str;	}
	public void setStop_cau		(String str)		{	stop_cau 	= str;	}
	public void setStop_doc_dt 	(String str)		{	stop_doc_dt = str;	}
	public void setStop_doc		(String str)		{	stop_doc 	= str;	}
	public void setStop_tax_dt	(String str)		{	stop_tax_dt = str;	}
	public void setReg_dt 		(String str)		{	reg_dt 		= str;	}
	public void setReg_id 		(String str)		{	reg_id 		= str;	}
	public void setCancel_dt	(String str)		{	cancel_dt 	= str;	}
	public void setCancel_id	(String str)		{	cancel_id 	= str;	}
	public void setDoc_id		(String str)		{	doc_id	 	= str;	}
	public void setRent_seq		(String str)		{	rent_seq	= str;	}
	public void setFirm_nm		(String str)		{	firm_nm		= str;	}
	
	public String getRent_mng_id()					{	return rent_mng_id;	}
	public String getRent_l_cd	()					{	return rent_l_cd;	}
	public String getSeq 		()					{	return seq;			}
	public String getStop_st 	()					{	return stop_st;		}
	public String getStop_s_dt	()					{	return stop_s_dt;	}
	public String getStop_e_dt	()					{	return stop_e_dt;	}
	public String getStop_cau	()					{	return stop_cau;	}
	public String getStop_doc_dt()					{	return stop_doc_dt;	}
	public String getStop_doc	()					{	return stop_doc;	}
	public String getStop_tax_dt()					{	return stop_tax_dt;	}
	public String getReg_dt 	()					{	return reg_dt;		}
	public String getReg_id 	()					{	return reg_id;		}
	public String getCancel_dt	()					{	return cancel_dt;	}
	public String getCancel_id	()					{	return cancel_id;	}
	public String getDoc_id		()					{	return doc_id;		}
	public String getRent_seq	()					{	return rent_seq;	}
	public String getFirm_nm	()					{	return firm_nm;		}
}
