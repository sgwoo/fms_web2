package acar.master_car;

public class MCarMaintBean
{
	private String car_mng_id;	//����������ȣ
	private int    seq_no;		//No
	private String che_kd;		//�˻籸��
	private String che_st_dt;	//��ȿ�Ⱓ������
	private String che_end_dt;	//��ȿ�Ⱓ������
	private String che_dt;		//�˻���
	private String che_no;		//�˻���
	private String che_comp;	//�˻��ü
	private int		che_amt;	//�˻���
	private int		che_km;		//����Ÿ�
	
	
	public MCarMaintBean()
	{
		car_mng_id	=	"";
		seq_no		=	0;		
		che_kd		=	"";		
		che_st_dt	=	"";	
		che_end_dt	=	"";	
		che_dt		=	"";	
		che_no		=	"";	
		che_comp	=	"";	
		che_amt		=	0;	
		che_km		=	0;	

	}


	
	public void setCar_mng_id	(String str)	{	car_mng_id = str;	}
	public void setSeq_no		(int i	)		{	seq_no = i ;		}
	public void setChe_kd		(String str)	{	che_kd = str;		}
	public void setChe_st_dt	(String str)	{	che_st_dt = str;	}
	public void setChe_end_dt	(String str)	{	che_end_dt = str;	}
	public void setChe_dt		(String str)	{	che_dt = str;		}
	public void setChe_no		(String str)	{	che_no = str;		}
	public void setChe_comp		(String str)	{	che_comp = str;		}
	public void setChe_amt		(int i)			{	che_amt = i;		}
	public void setChe_km		(int i)			{	che_km = i;			}



	public String getCar_mng_id		()	{	return	car_mng_id;	}   
	public int 	  getSeq_no			()	{	return	seq_no;		} 
	public String getChe_kd			()	{	return	che_kd;		}	
	public String getChe_st_dt		()	{	return	che_st_dt;	}
	public String getChe_end_dt		()	{	return	che_end_dt;	}
	public String getChe_dt			()	{	return	che_dt;		}
	public String getChe_no			()	{	return	che_no;		}
	public String getChe_comp		()	{	return	che_comp;	}
	public int    getChe_amt		()	{	return	che_amt;	}
	public int	  getChe_km			()	{	return	che_km;		}
	





}