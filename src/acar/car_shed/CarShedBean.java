package acar.car_shed;

public class CarShedBean
{
	private String shed_id;
	private String shed_nm;
	private String mng_off;
	private String mng_agnt;
	private String lea_nm;
	private String lea_comp_nm;
	private String lea_sta;
	private String lea_ssn;
	private String lea_ent_no;
	private String lea_item;
	private String lea_h_post;
	private String lea_h_addr;
	private String lea_h_tel;
	private String lea_o_post;
	private String lea_o_addr;
	private String lea_o_tel;
	private String lea_tax_st;
	private String lea_fax;
	private String lea_m_tel;
	private String lea_st;
	private String lea_st_dt;
	private String lea_end_dt;
	private String lend_own_nm;
	private String lend_comp_nm;
	private String lend_sta;
	private String lend_ssn;
	private String lend_ent_no;
	private String lend_item;
	private String lend_h_post;
	private String lend_h_addr;
	private String lend_o_post;
	private String lend_o_addr;
	private String lend_post;
	private String lend_addr;
	private String lend_h_tel;
	private String lend_o_tel;
	private String lend_m_tel;
	private String lend_tax;
	private String lend_rel;
	private String lend_fax;
	private String lend_tot_ar;
	private String lend_mng_agnt;
	private String lend_region;
	private String lend_cap_ar;
	private String lend_gov;
	private String lend_cla;
//건물관리대장 추가하면서 생성 20140318
	private String shed_st;
	private int bjg_amt;
	private int wsg_amt;
	private int hsjsg_amt;
	private String car_lend;
	private int car_lend_amt;
	private String car_lend_dt;
	private String im_in_dt;
	//20190711
	private String use_yn;				//계약여부
	private String lend_cap_car;	//수용대수
	private String cont_amt;			//계약금액

	
	public CarShedBean()
	{
		shed_id				= "";
		shed_nm			= "";
		mng_off			= "";
		mng_agnt			= "";
		lea_nm				= "";
		lea_comp_nm	= "";
		lea_sta				= "";
		lea_ssn				= "";
		lea_ent_no		= "";
		lea_item			= "";
		lea_h_post		= "";
		lea_h_addr		= "";
		lea_h_tel			= "";
		lea_o_post		= "";
		lea_o_addr		= "";
		lea_o_tel			= "";
		lea_tax_st			= "";
		lea_fax				= "";
		lea_m_tel			= "";
		lea_st				= "";
		lea_st_dt			= "";
		lea_end_dt		= "";
		lend_own_nm	= "";
		lend_comp_nm	= "";
		lend_sta			= "";
		lend_ssn			= "";
		lend_ent_no		= "";
		lend_item			= "";
		lend_h_post		= "";
		lend_h_addr		= "";
		lend_o_post		= "";
		lend_o_addr		= "";
		lend_post			= "";
		lend_addr			= "";
		lend_h_tel			= "";
		lend_o_tel			= "";
		lend_m_tel		= "";
		lend_tax			= "";
		lend_rel			= "";
		lend_fax			= "";
		lend_tot_ar		= "";
		lend_mng_agnt	= "";
		lend_region		= "";
		lend_cap_ar		= "";
		lend_gov			= "";
		lend_cla			= "";

		shed_st				= "";
		bjg_amt			= 0;
		wsg_amt			= 0;
		hsjsg_amt			= 0;	
		car_lend			= "";
		car_lend_amt	= 0;
		car_lend_dt		= "";
		im_in_dt			= "";
		use_yn				= "";
		lend_cap_car	= "";
		cont_amt			= "";
	}
	
	public void setShed_id(String str)			{	shed_id				= str;	}
	public void setShed_nm(String str)			{	shed_nm			= str;	}
	public void setMng_off(String str)			{	mng_off			= str;	}
	public void setMng_agnt(String str)			{	mng_agnt			= str;	}
	public void setLea_nm(String str)			{	lea_nm				= str;	}
	public void setLea_comp_nm(String str)	{	lea_comp_nm	= str;	}
	public void setLea_sta(String str)			{	lea_sta				= str;	}
	public void setLea_ssn(String str)			{	lea_ssn				= str;	}
	public void setLea_ent_no(String str)		{	lea_ent_no		= str;	}
	public void setLea_item(String str)			{	lea_item			= str;	}
	public void setLea_h_post(String str)		{	lea_h_post		= str;	}
	public void setLea_h_addr(String str)		{	lea_h_addr		= str;	}
	public void setLea_h_tel(String str)			{	lea_h_tel			= str;	}
	public void setLea_o_post(String str)		{	lea_o_post		= str;	}
	public void setLea_o_addr(String str)		{	lea_o_addr		= str;	}
	public void setLea_o_tel(String str)			{	lea_o_tel			= str;	}
	public void setLea_tax_st(String str)		{	lea_tax_st			= str;	}
	public void setLea_fax(String str)			{	lea_fax				= str;	}
	public void setLea_m_tel(String str)		{	lea_m_tel			= str;	}
	public void setLea_st(String str)				{	lea_st				= str;	}
	public void setLea_st_dt(String str)			{	lea_st_dt			= str;	}
	public void setLea_end_dt(String str)		{	lea_end_dt		= str;	}
	public void setLend_own_nm(String str)	{	lend_own_nm	= str;	}
	public void setLend_comp_nm(String str){	lend_comp_nm	= str;	}
	public void setLend_sta(String str)			{	lend_sta			= str;	}
	public void setLend_ssn(String str)			{	lend_ssn			= str;	}
	public void setLend_ent_no(String str)	{	lend_ent_no		= str;	}
	public void setLend_item(String str)		{	lend_item			= str;	}
	public void setLend_h_post(String str)	{	lend_h_post		= str;	}
	public void setLend_h_addr(String str)	{	lend_h_addr		= str;	}
	public void setLend_o_post(String str)	{	lend_o_post		= str;	}
	public void setLend_o_addr(String str)	{	lend_o_addr		= str;	}
	public void setLend_post(String str)		{	lend_post			= str;	}
	public void setLend_addr(String str)		{	lend_addr			= str;	}
	public void setLend_h_tel(String str)		{	lend_h_tel			= str;	}
	public void setLend_o_tel(String str)		{	lend_o_tel			= str;	}
	public void setLend_m_tel(String str)		{	lend_m_tel		= str;	}
	public void setLend_tax(String str)			{	lend_tax			= str;	}
	public void setLend_rel(String str)			{	lend_rel			= str;	}
	public void setLend_fax(String str)			{	lend_fax			= str;	}
	public void setLend_tot_ar(String str)		{	lend_tot_ar		= str;	}
	public void setLend_mng_agnt(String str){	lend_mng_agnt	= str;	}
	public void setLend_region(String str)		{	lend_region		= str;	}
	public void setLend_cap_ar(String str)	{	lend_cap_ar		= str;	}
	public void setLend_gov(String str)			{	lend_gov			= str;	}
	public void setLend_cla(String str)			{	lend_cla			= str;	}
	public void setShed_st(String str)			{	shed_st				= str;	}
	public void setBjg_amt(int val)				{	this.bjg_amt		= val;	}
	public void setWsg_amt(int val)				{	this.wsg_amt	= val;	}
	public void setHsjsg_amt(int val)			{	this.hsjsg_amt	= val;	}
	public void setCar_lend(String str)			{	car_lend			= str;	}
	public void setCar_lend_amt(int val)		{	this.car_lend_amt= val;	}
	public void setCar_lend_dt(String str)		{	car_lend_dt		= str;	}
	public void setIm_in_dt(String str)			{	im_in_dt			= str;	}
	public void setUse_yn(String str)				{	use_yn				= str;	}
	public void setLend_cap_car(String str)	{	lend_cap_car	= str;	}
	public void setCont_amt(String str)			{	cont_amt			= str;	}
	

	
	public String getShed_id()				{	return	shed_id;	}
	public String getShed_nm()				{	return	shed_nm;	}		
	public String getMng_off()				{	return	mng_off;	}
	public String getMng_agnt()				{	return	mng_agnt;	}
	public String getLea_nm()				{	return	lea_nm;	}
	public String getLea_comp_nm()		{	return	lea_comp_nm;	}
	public String getLea_sta()				{	return	lea_sta;	}
	public String getLea_ssn()				{	return	lea_ssn;	}
	public String getLea_ent_no()			{	return	lea_ent_no;	}
	public String getLea_item()				{	return	lea_item;	}
	public String getLea_h_post()			{	return	lea_h_post;	}
	public String getLea_h_addr()			{	return	lea_h_addr;	}
	public String getLea_h_tel()				{	return	lea_h_tel;	}
	public String getLea_o_post()			{	return	lea_o_post;	}
	public String getLea_o_addr()			{	return	lea_o_addr;	}
	public String getLea_o_tel()				{	return	lea_o_tel;	}
	public String getLea_tax_st()			{	return	lea_tax_st;	}
	public String getLea_fax()				{	return	lea_fax;	}
	public String getLea_m_tel()			{	return	lea_m_tel;	}
	public String getLea_st()					{	return	lea_st;	}		
	public String getLea_st_dt()				{	return	lea_st_dt;	}	
	public String getLea_end_dt()			{	return	lea_end_dt;	}	
	public String getLend_own_nm()		{	return	lend_own_nm;	}	
	public String getLend_comp_nm()	{	return	lend_comp_nm;	}
	public String getLend_sta()				{	return	lend_sta;	}	
	public String getLend_ssn()				{	return	lend_ssn;	}	
	public String getLend_ent_no()		{	return	lend_ent_no;	}	
	public String getLend_item()			{	return	lend_item;	}	
	public String getLend_h_post()		{	return	lend_h_post;	}	
	public String getLend_h_addr()		{	return	lend_h_addr;	}	
	public String getLend_o_post()		{	return	lend_o_post;	}	
	public String getLend_o_addr()		{	return	lend_o_addr;	}	
	public String getLend_post()			{	return	lend_post;	}	
	public String getLend_addr()			{	return	lend_addr;	}	
	public String getLend_h_tel()			{	return	lend_h_tel;	}	
	public String getLend_o_tel()			{	return	lend_o_tel;	}	
	public String getLend_m_tel()			{	return	lend_m_tel;	}	
	public String getLend_tax()				{	return	lend_tax;	}	
	public String getLend_rel()				{	return	lend_rel;	}	
	public String getLend_fax()				{	return	lend_fax;	}	
	public String getLend_tot_ar()			{	return	lend_tot_ar;	}	
	public String getLend_mng_agnt()	{	return	lend_mng_agnt;	}
	public String getLend_region()			{	return	lend_region;	}	
	public String getLend_cap_ar()		{	return	lend_cap_ar;	}	
	public String getLend_gov()				{	return	lend_gov;	}	
	public String getLend_cla()				{	return	lend_cla;	}	
	public String getShed_st()				{	return	shed_st;	}
	public int getBjg_amt()					{	return	bjg_amt;	}
	public int getWsg_amt()					{	return	wsg_amt;	}
	public int getHsjsg_amt()				{	return	hsjsg_amt;	}
	public String getCar_lend()				{	return	car_lend;	}
	public int getCar_lend_amt()			{	return	car_lend_amt;	}
	public String getCar_lend_dt()			{	return	car_lend_dt;	}
	public String getIm_in_dt()				{	return	im_in_dt;	}
	public String getUse_yn()					{	return	use_yn;	}
	public String getLend_cap_car()		{	return	lend_cap_car;	}
	public String getCont_amt()				{	return	cont_amt;	}
	
}