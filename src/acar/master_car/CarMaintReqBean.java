// �ڵ����˻� �Ƿڳ���
		
package acar.master_car;

public class CarMaintReqBean
{

	private String m1_no;			//�Ƿ�no
	private String mng_id;				//������
	private String car_mng_id;			//�ڵ�������
	private String rent_l_cd;		//���
	private String m1_dt;			//�Ƿ���
	private String m1_chk;			//�ܷڱ���: 1:����Ÿ, 2:����, 3:����
	private String m1_content;		//Ư�̻���
	private String reg_dt;			//�����
	private String update_dt;		//������
	private String che_dt;			//�˻���
	private String che_nm;		//�˻��
	private int    tot_dist;		//����Ÿ�
	private String che_type;		//�˻�����
	private int	   che_amt;		//�ݾ�
	private String che_remark;		//���
	private String car_no;		//������ȣ
	private String mng_nm;		//�Ƿ���
	private String req_dt;		//û����
	private String jung_dt;		//������
	private String use_yn;	
	private String off_id;   //�����ü	
	private String gubun; 
	
	public CarMaintReqBean()
	{
		m1_no	= "";    
		mng_id = "";    
		car_mng_id = "";    
		rent_l_cd = "";
		m1_dt = "";
		m1_chk = "";
		m1_content = "";    	
		reg_dt = "";    	
		update_dt = "";    
		che_dt = "";    
		che_nm = "";    
		tot_dist = 0;    
		che_type = "";    
		che_amt = 0;    
		che_remark = "";    
		car_no = "";  
		mng_nm = "";  
		req_dt = "";  
		jung_dt = "";   
		use_yn = "";   	
		off_id = "";   	 
		gubun = "";   	 
		
	}
	
	public void setM1_no(String str) 		{ m1_no		= str; }
	public void setMng_id(String str)		{ mng_id		= str; }    	
	public void setCar_mng_id(String str)	{ car_mng_id			= str; }		
	public void setRent_l_cd(String str)	{ rent_l_cd		= str; }    
	public void setM1_dt(String str)		{ m1_dt		= str; }    
	public void setM1_chk(String str)		{ m1_chk		= str; }
	public void setM1_content(String str)	{ m1_content		= str; }  
	public void setReg_dt(String str)		{ reg_dt		= str; }    
	public void setUpdate_dt(String str)	{ update_dt		= str; }    
	public void setChe_dt(String str)		{ che_dt		= str; }    
	public void setChe_nm(String str)		{ che_nm		= str; }    
	public void setTot_dist(int i)			{ tot_dist		= i;   }    	
	public void setChe_type(String str)		{ che_type		= str; }    
	public void setChe_amt(int i)			{ che_amt		= i;   }    	   
	public void setChe_remark(String str)	{ che_remark		= str; }  
	public void setCar_no(String str)	{ car_no		= str; }    
	public void setMng_nm(String str)	{ mng_nm		= str; }      
	public void setReq_dt(String str)	{ req_dt		= str; }      
	public void setJung_dt(String str)	{ jung_dt		= str; }      
	public void setUse_yn(String str)	{ use_yn		= str; }      
	public void setOff_id(String str)	{ off_id		= str; }      
	public void setGubun(String str)	{ gubun		= str; }      
	
	
	public String getM1_no() 		{ return m1_no;		}
	public String getMng_id()		{ return mng_id;		}
	public String getCar_mng_id()	{ return car_mng_id;	}
	public String getRent_l_cd()	{ return rent_l_cd;		}
	public String getM1_dt()		{ return m1_dt;		}
	public String getM1_chk()		{ return m1_chk;		}
	public String getM1_content()	{ return m1_content;	}	
	public String getReg_dt()		{ return reg_dt;		}
	public String getUpdate_dt()	{ return update_dt;		}
	public String getChe_dt()		{ return che_dt;		}
	public String getChe_nm()		{ return che_nm;		}
	public int getTot_dist()		{ return tot_dist;	}
	public String getChe_type()		{ return che_type;		}
	public int getChe_amt()			{ return che_amt;		}
	public String getChe_remark()	{ return che_remark;	}
	public String getCar_no()		{ return car_no;	}
	public String getMng_nm()		{ return mng_nm;	}
	public String getReq_dt()		{ return req_dt;	}
	public String getJung_dt()		{ return jung_dt;	}
	public String getUse_yn()		{ return use_yn;	}
	public String getOff_id()		{ return off_id;	}
	public String getGubun()		{ return gubun;	}
	

}