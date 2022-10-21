package acar.cost;

public class CostNeomBean
{
	private String cost_dt = "";
	private int seq = 0;
	private String cost_id = "";
	private String gubun = "";  //비용항목
	private String remark = "";
	private int cost_amt = 0;
	private String c_st = "";  //탁송구분 1:신차 2:기타
	
	private String rent_mng_id = "";
	private String rent_l_cd = "";
	private String client_id = "";
	private String car_mng_id = "";
	private String car_no = "";
	private String car_num = "";
	private String firm_nm = "";
	
	
	public CostNeomBean()
	{
		cost_dt = "";	
		seq = 0;
		cost_id = "";
		gubun = "";
		remark = "";
		cost_amt = 0;
		c_st = "";
		
		rent_mng_id = "";
		rent_l_cd = "";
		client_id = "";
		car_mng_id = "";
		car_no = "";
		car_num = "";
		firm_nm = "";
		
	}
	
	public void setCost_dt(String str)	{	if(str==null) str="";	cost_dt	= str; }
	public void setSeq	(int val)		{	seq = val; }
	public void setCost_id(String str)	{	if(str==null) str="";	cost_id	= str; }
	public void setGubun(String str)	{	if(str==null) str="";	gubun	= str; }
	public void setRemark(String str)	{	if(str==null) str="";	remark	= str; }
	public void setCost_amt	(int val)	{	cost_amt = val; }
	public void setC_st(String str)		{	if(str==null) str="";	c_st	= str; }
	
	public void setRent_mng_id(String str)	{	if(str==null) str="";	rent_mng_id	= str; }
	public void setRent_l_cd(String str)	{	if(str==null) str="";	rent_l_cd	= str; }
	public void setClient_id(String str)	{	if(str==null) str="";	client_id	= str; }
	public void setCar_mng_id(String str)	{	if(str==null) str="";	car_mng_id	= str; }
	public void setCar_no(String str)		{	if(str==null) str="";	car_no	= str; }
	public void setCar_num(String str)		{	if(str==null) str="";	car_num	= str; }
	public void setFirm_nm(String str)		{	if(str==null) str="";	firm_nm	= str; }
		
	public String getCost_dt()	{	return cost_dt;		}
	public int    getSeq()		{	return seq;	}
	public String getCost_id()	{	return cost_id;		}
	public String getGubun()	{	return gubun;	}
	public String getRemark()	{	return remark;	}
	public int    getCost_amt()	{	return cost_amt;	}
	public String getC_st()		{	return c_st;	}
	
	public String getRent_mng_id()		{	return rent_mng_id;	}
	public String getRent_l_cd()		{	return rent_l_cd;	}
	public String getClient_id()		{	return client_id;	}
	public String getCar_mng_id()		{	return car_mng_id;	}
	public String getCar_no()		{	return car_no;	}
	public String getCar_num()		{	return car_num;	}
	public String getFirm_nm()		{	return firm_nm;	}
	
}