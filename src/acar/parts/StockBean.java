package acar.parts;

public class StockBean
{
	private String parts_no;
	private String location;
	private String kisu;
	private String mm;
	private int  ip_qty;  //입고수량
	private int ch_qty;  //출고수량 
	private String reg_dt;
	private String reg_id;
	private String upd_dt;
	private String upd_id;
	private String car_comp_id;
	private String car_cd;

	
	public StockBean()
	{
		parts_no = "";
		location = "";
		kisu = "";
		mm = "";
		ip_qty = 0;	
		ch_qty =0;
		reg_dt = "";
		reg_id = "";
		upd_dt = "";
		upd_id = "";
		car_comp_id = "";
		car_cd = "";
	}
	
	public void setParts_no(String str)	{	parts_no = str;	}
	public void setLocation(String str)	{	location = str;	}
	public void setKisu(String str)	{	kisu = str;	}
	public void setMm(String str)	{	mm = str;	}
	public void setIp_qty(int i){			         ip_qty = i;	}
	public void setCh_qty(int i){			         ch_qty = i;	}	
	public void setReg_dt(String str)	{	reg_dt= str;	}	
	public void setReg_id(String str)	{	reg_id= str;	}
	public void setUpd_dt(String str)	{	upd_dt= str;	}	
	public void setUpd_id(String str)	{	upd_id= str;	}
	public void setCar_comp_id(String str)	{	car_comp_id= str;	}
	public void setCar_cd(String str)	{	car_cd= str;	}

	public String getParts_no()	{	return parts_no;	}
	public String getLocation()	{	return location;	}
	public String getKisu()	{	return kisu;	}
	public String getMm()	{	return mm;	}
	public int getIp_qty()	{		return ip_qty;		}	
	public int getCh_qty()	{		return ch_qty;		}	
	public String getReg_dt()	{	return reg_dt;	}
	public String getReg_id()	{	return reg_id;	}
	public String getUpd_dt()	{	return upd_dt;	}
	public String getUpd_id()	{	return upd_id;	}
	public String getCar_comp_id()	{	return car_comp_id;	}
	public String getCar_cd()	{	return car_cd;	}
	
}