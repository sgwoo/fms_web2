package acar.parts;

public class PriceBean
{
	private String parts_no;
	private int seq_no;
	private int p_s_amt;   //소비자가
	private int p_v_amt;
	private int r_s_amt;  // 구매가격
	private int r_v_amt;  // 
	private int dc_s_amt;  // 
	private int dc_rate;  // 
	private String gubun;  // 
	private String app_dt;  // 
	private String reg_dt;
	private String reg_id;
	private String car_comp_id;
	private String car_cd;
		
	public PriceBean()
	{
		parts_no = "";
		seq_no = 0;
		p_s_amt =0;
		p_v_amt = 0;
		r_s_amt = 0;	
		r_v_amt = 0;
		dc_s_amt = 0;
		dc_rate = 0;
		gubun = "";
		app_dt = "";
		reg_dt = "";
		reg_id = "";
		car_comp_id = "";
		car_cd = "";
	}
	
	public void setParts_no(String str)	{	parts_no = str;	}
	public void setSeq_no(int i){			seq_no = i;	}
	public void setP_s_amt(int i){			p_s_amt = i;	}
	public void setP_v_amt(int i){			p_v_amt = i;	}
	public void setR_s_amt(int i){			r_s_amt = i;	}
	public void setR_v_amt(int i){			r_v_amt = i;	}
	public void setDc_s_amt(int i){		dc_s_amt = i;	}
	public void setDc_rate(int i){			dc_rate = i;	}
	public void setGubun(String str)	{	gubun = str;	}
	public void setApp_dt(String str)	{	app_dt = str;	}
	public void setReg_dt(String str)	{	reg_dt= str;	}	
	public void setReg_id(String str)	{	reg_id= str;	}
	public void setCar_comp_id(String str)	{	car_comp_id= str;	}
	public void setCar_cd(String str)	{	car_cd= str;	}

	public String getParts_no()	{	return parts_no;	}
	public int getSeq_no(){		return seq_no;		}	
	public int getP_s_amt(){		return p_s_amt;		}	
	public int getP_v_amt(){		return p_v_amt;		}	
	public int getR_s_amt(){		return r_s_amt;		}	
	public int getR_v_amt(){		return r_v_amt;		}	
	public int getDc_s_amt(){		return dc_s_amt;		}	
 	public int getDc_rate(){		return dc_rate;		}	
	public String getGubun()	{	return gubun;	}
	public String getApp_dt()	{	return app_dt;	}
	public String getReg_dt()	{	return reg_dt;	}
	public String getReg_id()	{	return reg_id;	}
	public String getCar_comp_id()	{	return car_comp_id;	}
	public String getCar_cd()	{	return car_cd;	}
	
}