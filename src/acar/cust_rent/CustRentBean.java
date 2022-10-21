package acar.cust_rent;

public class CustRentBean
{
	private String rent_mng_id	= "";
	private String rent_l_cd	= "";
	private String brch_nm		= "";
	private String bus_nm 		= "";	//bus_id
	private String car_nm		= "";
	private String opt			= "";
	private String colo			= "";
	private int    car_price	= 0;
	private String dlv_est_dt	= "";
	private int    fee_s_amt	= 0;
	private int    fee_v_amt	= 0;
	private int    grt_amt		= 0;
	private int    pp_s_amt		= 0;
	private int    pp_v_amt		= 0;
	private String fee_pay_tm	= "";
	private String fee_est_day	= "";
	private String fee_pay_start_dt	= "";
	private String fee_pay_end_dt	= "";
	private String ins_com_nm	= "";
	private String age_scp		= "";
	private int    imm_amt		= 0;
	private String agnt_tel		= "";
	private String agnt_imgn_tel	= "";
	private String p_zip	= "";
	private String p_addr	= "";
	private String r_site	= "";
	private String ins_start_dt	= "";
	private String ins_exp_dt	= "";

	public void setRent_mng_id(String str)	{	rent_mng_id	    = str;	}
	public void setRent_l_cd(String str)	{	rent_l_cd	    = str;	}
	public void setBrch_nm(String str)		{	brch_nm		    = str;	}
	public void setBus_nm(String str)		{	bus_nm 		    = str;	}
	public void setCar_nm(String str)		{	car_nm		    = str;	}
	public void setOpt(String str)			{	opt			    = str;	}
	public void setColo(String str)			{	colo			= str;	}
	public void setCar_price(int i)			{	car_price	    = i;	}
	public void setDlv_est_dt(String str)	{	dlv_est_dt	    = str;	}
	public void setFee_s_amt(int i)			{	fee_s_amt	    = i;	}
	public void setFee_v_amt(int i)			{	fee_v_amt	    = i;	}
	public void setGrt_amt(int i)			{	grt_amt		    = i;	}
	public void setPp_s_amt(int i)			{	pp_s_amt		= i;	}
	public void setPp_v_amt(int i)			{	pp_v_amt		= i;	}
	public void setFee_pay_tm(String str)	{	fee_pay_tm	    = str;	}
	public void setFee_est_day(String str)	{	fee_est_day	    = str;	}
	public void setFee_pay_start_dt(String str){fee_pay_start_dt= str;	}
	public void setFee_pay_end_dt(String str){	fee_pay_end_dt  = str;	}
	public void setIns_com_nm(String str)	{	ins_com_nm	    = str;	}
	public void setAge_scp(String str)		{	age_scp		    = str;	}
	public void setImm_amt(int i)			{	imm_amt		    = i;	}
	public void setAgnt_tel(String str)		{	agnt_tel		= str;	}
	public void setAgnt_imgn_tel(String str){	agnt_imgn_tel   = str;	}
	public void setP_zip(String str){	p_zip	   = str;	}
	public void setP_addr(String str){	p_addr     = str;	}
	public void setR_site(String str){	r_site     = str;	}
	public void setIns_start_dt(String str){	ins_start_dt     = str;	}
	public void setIns_exp_dt(String str){	ins_exp_dt     = str;	}

	public String getRent_mng_id()	{	return rent_mng_id;	}
	public String getRent_l_cd()	{	return	rent_l_cd;	}
	public String getBrch_nm()		{	return	brch_nm;	}
	public String getBus_nm()		{	return	bus_nm;	}
	public String getCar_nm()		{	return	car_nm;	}
	public String getOpt()			{	return	opt;	}
	public String getColo()			{	return	colo;	}
	public int    getCar_price()	{	return	car_price;	}
	public String getDlv_est_dt()	{	return	dlv_est_dt;	}
	public int    getFee_s_amt()	{	return	fee_s_amt;	}
	public int    getFee_v_amt()	{	return	fee_v_amt;	}
	public int    getGrt_amt()		{	return	grt_amt;	}
	public int    getPp_s_amt()		{	return	pp_s_amt;	}
	public int    getPp_v_amt()		{	return	pp_v_amt;	}
	public String getFee_pay_tm()	{	return	fee_pay_tm;	}
	public String getFee_est_day()	{	return	fee_est_day;	}
	public String getFee_pay_start_dt(){return	fee_pay_start_dt;	}
	public String getFee_pay_end_dt(){	return	fee_pay_end_dt;	}
	public String getIns_com_nm()	{	return	ins_com_nm;	}
	public String getAge_scp()		{	return	age_scp;	}
	public int    getImm_amt()		{	return	imm_amt;	}
	public String getAgnt_tel()		{	return	agnt_tel;	}
	public String getAgnt_imgn_tel(){	return	agnt_imgn_tel;	}
	public String getP_zip(){	return	p_zip;	}
	public String getP_addr(){	return	p_addr;	}
	public String getR_site(){	return	r_site;	}
	public String getIns_start_dt(){	return ins_start_dt; }
	public String getIns_exp_dt(){	return ins_exp_dt; }
}