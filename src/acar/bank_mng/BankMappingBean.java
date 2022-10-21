package acar.bank_mng;

import java.util.*;

public class BankMappingBean
{

	private String car_mng_id;
	private String lend_id;
	private String loan_st_dt;	//대출신청일
	private int    sup_amt;		//공급가액
	private int    loan_amt;	//대출금액
	private String ref_dt;		//결제기준일
	private String sup_dt;		//지급제시일
	private String loan_end_dt;	//대출만기일
	private String f_rat;		//선이자율
	private int    f_amt;		//선이자금액
	private String f_term;		//선이자기간
	private String days;		//일수
	private int    dif_amt;		//입금액
	private String loan_ack_dt;	//대출승인일
	private String loan_rec_dt;	//대출입금일
	private String note;		//기타
	//추가
	private int spe_amt;		//소비자가
	private int loan_sch_amt;	//대출예상금액
	private int pay_sch_amt;	//지출예상금액
	private String pay_dt;		//지출일자
	private String cpt_cd;		//금융사아이디
	private String lend_int;	//이자율
	private int cltr_amt;		//근저당설정금액
	private String max_cltr_rat;//대출금액대비율
	private int cltr_id;		//근저당설정일련번호

	private String rent_mng_id;
	private String rent_l_cd;
	private String rent_dt;
	private String dlv_dt;
	private String firm_nm;
	private String client_nm;
	private String car_nm;	//차종
	private String car_no;
	private int sup_v_amt;
	private int fee_amt;
	private String imsi_chk;
	private String rtn_seq;
	private String car_name;
	private int sup_amt_85per;	//구입가85%
	private int sup_amt_70per;	//구입가70%
	
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