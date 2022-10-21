package acar.bank_mng;

import java.util.*;

public class BankMappingBean
{

	private String car_mng_id;
	private String lend_id;
	private String loan_st_dt;	//�����û��
	private int    sup_amt;		//���ް���
	private int    loan_amt;	//����ݾ�
	private String ref_dt;		//����������
	private String sup_dt;		//����������
	private String loan_end_dt;	//���⸸����
	private String f_rat;		//��������
	private int    f_amt;		//�����ڱݾ�
	private String f_term;		//�����ڱⰣ
	private String days;		//�ϼ�
	private int    dif_amt;		//�Աݾ�
	private String loan_ack_dt;	//���������
	private String loan_rec_dt;	//�����Ա���
	private String note;		//��Ÿ
	//�߰�
	private int spe_amt;		//�Һ��ڰ�
	private int loan_sch_amt;	//���⿹��ݾ�
	private int pay_sch_amt;	//���⿹��ݾ�
	private String pay_dt;		//��������
	private String cpt_cd;		//��������̵�
	private String lend_int;	//������
	private int cltr_amt;		//�����缳���ݾ�
	private String max_cltr_rat;//����ݾ״����
	private int cltr_id;		//�����缳���Ϸù�ȣ

	private String rent_mng_id;
	private String rent_l_cd;
	private String rent_dt;
	private String dlv_dt;
	private String firm_nm;
	private String client_nm;
	private String car_nm;	//����
	private String car_no;
	private int sup_v_amt;
	private int fee_amt;
	private String imsi_chk;
	private String rtn_seq;
	private String car_name;
	private int sup_amt_85per;	//���԰�85%
	private int sup_amt_70per;	//���԰�70%
	
	public BankMappingBean()
	{
		car_mng_id	= "";
		lend_id		= "";
		loan_st_dt	= "";
		sup_amt		= 0;
		loan_amt	= 0;
		ref_dt		= "";
		sup_dt		= "";
		loan_end_dt	= "";
		f_rat		= "";
		f_amt		= 0;
		f_term		= "";
		days		= "";
		dif_amt		= 0;
		loan_ack_dt	= "";
		loan_rec_dt	= "";
		note		= "";
		rent_mng_id	= "";
		rent_l_cd	= "";
		rent_dt		= "";
		dlv_dt		= "";
		firm_nm		= "";
		client_nm	= "";
		car_nm		= "";
		car_no		= "";
		spe_amt		= 0;
		loan_sch_amt = 0;
		pay_sch_amt = 0;
		pay_dt		= "";
		cpt_cd		= "";
		lend_int	= "";
		cltr_amt	= 0;
		sup_v_amt	= 0;
		fee_amt		= 0;
		max_cltr_rat = "";
		cltr_id		= 0;
		imsi_chk	= "";
		rtn_seq		= "";
		car_name	= "";
		sup_amt_85per= 0;
		sup_amt_70per= 0;

	}
	
	public void setCar_mng_id(String str)	{	car_mng_id	= str;	}
	public void setLend_id(String str)		{	lend_id		= str;	}
	public void setLoan_st_dt(String str)	{	loan_st_dt	= str;	}
	public void setSup_amt(int i)			{	sup_amt		= i;	}
	public void setLoan_amt(int i)			{	loan_amt	= i;	}
	public void setRef_dt(String str)		{	ref_dt		= str;	}
	public void setSup_dt(String str)		{	sup_dt		= str;	}
	public void setLoan_end_dt(String str)	{	loan_end_dt	= str;	}
	public void setF_rat(String str)		{	f_rat		= str;	}
	public void setF_amt(int i)				{	f_amt		= i;	}
	public void setF_term(String str)		{	f_term		= str;	}
	public void setDays(String str)			{	days		= str;	}
	public void setDif_amt(int i)			{	dif_amt		= i;	}
	public void setLoan_ack_dt(String str)	{	loan_ack_dt	= str;	}
	public void setLoan_rec_dt(String str)	{	loan_rec_dt	= str;	}
	public void setNote(String str)			{	note		= str;	}
	public void setRent_mng_id(String str)	{	rent_mng_id	= str;	}
	public void setRent_l_cd(String str)	{	rent_l_cd	= str;	}
	public void setRent_dt(String str)		{	rent_dt		= str;	}
	public void setDlv_dt(String str)		{	dlv_dt		= str;	}
	public void setFirm_nm(String str)		{	firm_nm		= str;	}
	public void setClient_nm(String str)	{	client_nm	= str;	}
	public void setCar_nm(String str)		{	car_nm		= str;	}
	public void setCar_no(String str)		{	car_no		= str;	}
	public void setSpe_amt(int i)			{	spe_amt		= i;	}
	public void setLoan_sch_amt(int i)		{	loan_sch_amt= i;	}
	public void setPay_sch_amt(int i)		{	pay_sch_amt	= i;	}
	public void setPay_dt(String str)		{	pay_dt		= str;	}
	public void setCpt_cd(String str)		{	cpt_cd		= str;	}
	public void setLend_int(String str)		{	lend_int	= str;	}
	public void setCltr_amt(int i)			{	cltr_amt	= i;	}
	public void setSup_v_amt(int i)			{	sup_v_amt	= i;	}
	public void setFee_amt(int i)			{	fee_amt		= i;	}
	public void setMax_cltr_rat(String str)	{	max_cltr_rat= str;	}
	public void setCltr_id(int i)			{	cltr_id		= i;	}
	public void setImsi_chk(String str)		{	imsi_chk	= str;	}
	public void setRtn_seq(String str)		{	rtn_seq		= str;	}
	public void setCar_name(String str)		{	car_name	= str;	}
	public void setSup_amt_85per(int i)		{	sup_amt_85per= i;	}
	public void setSup_amt_70per(int i)		{	sup_amt_70per= i;	}

	
	public String getCar_mng_id()	{	return	car_mng_id;	}
	public String getLend_id()		{	return	lend_id;	}
	public String getLoan_st_dt()	{	return	loan_st_dt;	}
	public int    getSup_amt()		{	return	sup_amt;	}
	public int    getLoan_amt()		{	return	loan_amt;	}
	public String getRef_dt()		{	return	ref_dt;		}
	public String getSup_dt()		{	return	sup_dt;		}
	public String getLoan_end_dt()	{	return	loan_end_dt;}
	public String getF_rat()		{	return	f_rat;		}
	public int    getF_amt()		{	return	f_amt;		}
	public String getF_term()		{	return	f_term;		}
	public String getDays()			{	return	days;		}
	public int    getDif_amt()		{	return	dif_amt;	}
	public String getLoan_ack_dt()	{	return	loan_ack_dt;}
	public String getLoan_rec_dt()	{	return	loan_rec_dt;}
	public String getNote()			{	return	note;		}
	public String getRent_mng_id()	{	return rent_mng_id;	}
	public String getRent_l_cd()	{	return rent_l_cd;	}
	public String getRent_dt()		{	return rent_dt;		}
	public String getDlv_dt()		{	return dlv_dt;		}
	public String getFirm_nm()		{	return firm_nm;		}
	public String getClient_nm()	{	return client_nm;	}
	public String getCar_nm()		{	return car_nm;		}
	public String getCar_no()		{	return car_no;		}
	public int getSpe_amt()			{	return spe_amt;		}
	public int getLoan_sch_amt()	{	return loan_sch_amt;}
	public int getPay_sch_amt()		{	return pay_sch_amt;	}
	public String getPay_dt()		{	return pay_dt;		}
	public String getCpt_cd()		{	return cpt_cd;		}
	public String getLend_int()		{	return lend_int;	}
	public int getCltr_amt()		{	return cltr_amt;	}
	public int getSup_v_amt()		{	return sup_v_amt;	}
	public int getFee_amt()			{	return fee_amt;		}
	public String getMax_cltr_rat() {	return max_cltr_rat;}
	public int getCltr_id()			{	return cltr_id;		}
	public String getImsi_chk()		{	return imsi_chk;	}
	public String getRtn_seq()		{	return rtn_seq;		}
	public String getCar_name()		{	return car_name;	}
	public int getSup_amt_85per()	{	return sup_amt_85per;}
	public int getSup_amt_70per()	{	return sup_amt_70per;}

}