package acar.parts;

public class PartsBean
{
	private String parts_no;
	private String car_comp_id;
	private String car_cd;
	private String parts_nm;
	private String a_st;  //적용모델
	private String c_st;  //호환성 	
	private String reg_dt;
	private String reg_id;
	private String maker_nm;
	private String car_nm;
	
	public PartsBean()
	{
		parts_no = "";
		car_comp_id = "";
		car_cd = "";
		parts_nm = "";
		a_st = "";	
		c_st = "";
		reg_dt = "";
		reg_id = "";
		maker_nm = "";
		car_nm = "";
	}
	
	public void setParts_no(String str)	{	parts_no = str;	}
	public void setCar_comp_id(String str)	{	car_comp_id = str;	}
	public void setCar_cd(String str)	{	car_cd = str;	}
	public void setParts_nm(String str)	{	parts_nm = str;	}
	public void setA_st(String str)	{	a_st = str;	}
	public void setC_st(String str)	{	c_st = str;	}
	public void setReg_dt(String str)	{	reg_dt= str;	}	
	public void setReg_id(String str)	{	reg_id= str;	}
	public void setMaker_nm(String str)	{	maker_nm= str;	}	
	public void setCar_nm(String str)	{	car_nm= str;	}

	public String getParts_no()	{	return parts_no;	}
	public String getCar_comp_id()	{	return car_comp_id;	}
	public String getCar_cd()	{	return car_cd;	}
	public String getParts_nm()	{	return parts_nm;	}
	public String getA_st()	{	return a_st;	}
	public String getC_st()	{	return c_st;	}
	public String getReg_dt()	{	return reg_dt;	}
	public String getReg_id()	{	return reg_id;	}
	public String getMaker_nm()	{	return maker_nm;	}
	public String getCar_nm()	{	return car_nm;	}
	
}