/*
 * Ư�Ҽ�����
 */
package acar.con_tax;

public class TaxScdBean
{
	private String rent_mng_id;	//��������ȣ
	private String rent_l_cd;	//����ȣ    
	private String seq;			//Ư�Ҽ���ȣ
	private String car_mng_id;	//����������ȣ        
	private String sur_rate;	//�ܰ���
	private int sur_amt;		//������
	private String tax_rate;	//Ư�Ҽ���
	private int spe_tax_amt;	//Ư�Ҽ�
	private int edu_tax_amt;	//������(Ư�Ҽ���30%)
	private String est_dt;		//���⿹������
	private String pay_dt;		//��������
	private int pay_amt;		//����ݾ�
	private String reg_dt;		//�������
	private String reg_id;		//�����
	private String update_dt;	//��������
	private String update_id;	//������
	private String cls_man_st;	//�Ű� �絵��
	private String rtn_dt;		//ȯ������
	private int rtn_amt;		//ȯ�ޱݾ�
	private String tax_st;		//ȯ�Ա���
	private String tax_apply;	//ȯ�Լ����������
	private String tax_come_dt;	//ȯ�Ի����߻�����
	private String rtn_cau;		//ȯ�޻���
	private int car_fs_amt;		//�鼼���԰�
	private String car_num;		//�����ȣ
	private String init_reg_dt;	//���ʵ����
	private String est_dt2;		//�бⳳ�ο�����

	public TaxScdBean()
	{
		rent_mng_id = "";
		rent_l_cd   = ""; 
		seq			= "";
		car_mng_id	= "";
		sur_rate    = "";
		sur_amt		= 0;
		tax_rate	= "";
		spe_tax_amt = 0;
		edu_tax_amt = 0;
		est_dt		= "";
		pay_dt		= "";
		pay_amt     = 0;
		reg_dt		= "";
		reg_id		= "";
		update_dt	= "";
		update_id	= "";
		cls_man_st	= "";
		rtn_dt		= "";
		rtn_amt     = 0;
		tax_st		= "";
		tax_apply	= "";
		tax_come_dt = "";
		rtn_cau		= "";
		car_fs_amt  = 0;
		car_num		= "";
		init_reg_dt	= "";
		est_dt2		= "";
	}

	
	public void setRent_mng_id(String str)	{ rent_mng_id	= str; } 
	public void setRent_l_cd(String str)	{ rent_l_cd		= str; } 
	public void setSeq(String str)			{ seq			= str; } 
	public void setCar_mng_id(String str)	{ car_mng_id	= str; }    
	public void setSur_rate(String str)		{ sur_rate		= str; } 
	public void setSur_amt(int i)			{ sur_amt		= i;   } 
	public void setTax_rate(String str)		{ tax_rate		= str; } 
	public void setSpe_tax_amt(int i)		{ spe_tax_amt	= i;   } 
	public void setEdu_tax_amt(int i)		{ edu_tax_amt	= i;   } 
	public void setEst_dt(String str)		{ est_dt		= str; } 
	public void setPay_dt(String str)		{ pay_dt		= str; } 
	public void setPay_amt(int i)			{ pay_amt		= i;   } 
	public void setReg_dt(String str)		{ reg_dt		= str; } 
	public void setReg_id(String str)		{ reg_id		= str; } 
	public void setUpdate_dt(String str)	{ update_dt		= str; }
	public void setUpdate_id(String str)	{ update_id		= str; }
	public void setCls_man_st(String str)	{ cls_man_st	= str; }
	public void setRtn_dt(String str)		{ rtn_dt		= str; } 
	public void setRtn_amt(int i)			{ rtn_amt		= i;   } 
	public void setTax_st(String str)		{ tax_st		= str; }
	public void setTax_apply(String str)	{ tax_apply		= str; }
	public void setTax_come_dt(String str)	{ tax_come_dt	= str; }
	public void setRtn_cau(String str)		{ rtn_cau		= str; } 
	public void setCar_fs_amt(int i)		{ car_fs_amt	= i;   } 
	public void setCar_num(String str)		{ car_num		= str; } 
	public void setInit_reg_dt(String str)	{ init_reg_dt	= str; } 
	public void setEst_dt2(String str)		{ est_dt2		= str; } 
	

	public String getRent_mng_id()	{ return rent_mng_id;	} 
	public String getRent_l_cd()	{ return rent_l_cd;		} 
	public String getSeq()			{ return seq; 			} 
	public String getCar_mng_id()	{ return car_mng_id; 	}    
	public String getSur_rate()		{ return sur_rate; 		} 
	public int    getSur_amt()		{ return sur_amt;		} 
	public String getTax_rate()		{ return tax_rate;		} 
	public int    getSpe_tax_amt()	{ return spe_tax_amt;	} 
	public int    getEdu_tax_amt()	{ return edu_tax_amt;	} 
	public String getEst_dt()		{ return est_dt;		} 
	public String getPay_dt()		{ return pay_dt;		}  
	public int    getPay_amt()		{ return pay_amt;		} 
	public String getReg_dt()		{ return reg_dt;		} 
	public String getReg_id()		{ return reg_id;		} 
	public String getUpdate_dt()	{ return update_dt;		}  
	public String getUpdate_id()	{ return update_id;		}  
	public String getCls_man_st()	{ return cls_man_st;	} 
	public String getRtn_dt()		{ return rtn_dt;		}  
	public int    getRtn_amt()		{ return rtn_amt;		} 	
	public String getTax_st()		{ return tax_st;		}  
	public String getTax_apply()	{ return tax_apply;		}  
	public String getTax_come_dt()	{ return tax_come_dt;	} 
	public String getRtn_cau()		{ return rtn_cau;		}  
	public int    getCar_fs_amt()	{ return car_fs_amt;	} 
	public String getCar_num()		{ return car_num;		}  
	public String getInit_reg_dt()	{ return init_reg_dt;	}  
	public String getEst_dt2()		{ return est_dt2;		} 

}